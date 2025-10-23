#! /usr/bin/env nix-shell
/*
#! nix-shell -i zx -p zx
*/

cd(__dirname)
const nixpkgs = (await $`git rev-parse --show-toplevel`).stdout.trim()
const $nixpkgs = $({
  cwd: nixpkgs
})

const dummy_hash = 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='

const lockfile_file = './info.json'
const lockfile_initial = fs.readJsonSync(lockfile_file)
function flush_to_file() {
  fs.writeJsonSync(lockfile_file, lockfile, { spaces: 2 })
}
const flush_to_file_proxy = {
  get(obj, prop) {
    const value = obj[prop]
    return typeof value == 'object' ? new Proxy(value, flush_to_file_proxy) : value
  },

  set(obj, prop, value) {
    obj[prop] = value
    flush_to_file()
    return true
  },
}
const lockfile = new Proxy(structuredClone(lockfile_initial), flush_to_file_proxy)
const ungoogled_rev = argv['ungoogled-chromium-rev']

for (const attr_path of Object.keys(lockfile)) {
  const ungoogled = attr_path === 'ungoogled-chromium'

  if (!argv[attr_path] && !(ungoogled && ungoogled_rev)) {
    console.log(`[${attr_path}] Skipping ${attr_path}. Pass --${attr_path} as argument to update.`)
    continue
  }

  const version_nixpkgs = !ungoogled ? lockfile[attr_path].version : lockfile[attr_path].deps['ungoogled-patches'].rev
  const version_upstream = !ungoogled ? await get_latest_chromium_release('linux') :
    ungoogled_rev ?? await get_latest_ungoogled_release()

  console.log(`[${attr_path}] ${chalk.red(version_nixpkgs)} (nixpkgs)`)
  console.log(`[${attr_path}] ${chalk.green(version_upstream)} (upstream)`)

  if (ungoogled_rev || version_greater_than(version_upstream, version_nixpkgs)) {
    console.log(`[${attr_path}] ${chalk.green(version_upstream)} from upstream is newer than our ${chalk.red(version_nixpkgs)}...`)

    let ungoogled_patches = ungoogled ? await fetch_ungoogled(version_upstream) : undefined

    // For ungoogled-chromium we need to remove the patch revision (e.g. 130.0.6723.116-1 -> 130.0.6723.116)
    // by just using the chromium_version.txt content from the patches checkout (to also work with commit revs).
    const version_chromium = ungoogled_patches?.chromium_version ?? version_upstream

    const chromium_rev = await chromium_resolve_tag_to_rev(version_chromium)

    lockfile[attr_path] = {
      version: version_chromium,
      chromedriver: !ungoogled ? await fetch_chromedriver_binaries(await get_latest_chromium_release('mac')) : undefined,
      deps: {
        depot_tools: {},
        gn: await fetch_gn(chromium_rev, lockfile_initial[attr_path].deps.gn),
        'ungoogled-patches': !ungoogled ? undefined : {
          rev: ungoogled_patches.rev,
          hash: ungoogled_patches.hash,
        },
        npmHash: dummy_hash,
      },
      DEPS: {},
    }

    const depot_tools = await fetch_depot_tools(chromium_rev, lockfile_initial[attr_path].deps.depot_tools)
    lockfile[attr_path].deps.depot_tools = {
      rev: depot_tools.rev,
      hash: depot_tools.hash,
    }

    // DEPS update loop
    lockfile[attr_path].DEPS = await resolve_DEPS(depot_tools.out, chromium_rev)
    for (const [path, value] of Object.entries(lockfile[attr_path].DEPS)) {
      delete value.fetcher
      delete value.postFetch

      if (value.url === 'https://chromium.googlesource.com/chromium/src.git') {
        value.recompress = true
      }

      const cache_hit = (() => {
        for (const attr_path in lockfile_initial) {
          const cache = lockfile_initial[attr_path].DEPS[path]
          const hits_cache =
            cache !== undefined &&
            value.url === cache.url &&
            value.rev === cache.rev &&
            value.recompress === cache.recompress &&
            cache.hash !== undefined &&
            cache.hash !== '' &&
            cache.hash !== dummy_hash

          if (hits_cache) {
            cache.attr_path = attr_path
            return cache;
          }
        }
      })();

      if (cache_hit) {
        console.log(`[${chalk.green(path)}] Reusing hash from previous info.json for ${cache_hit.url}@${cache_hit.rev} from ${cache_hit.attr_path}`)
        value.hash = cache_hit.hash
        continue
      }

      console.log(`[${chalk.red(path)}] FOD prefetching ${value.url}@${value.rev}...`)
      value.hash = await prefetch_FOD('-A', `${attr_path}.browser.passthru.chromiumDeps."${path}"`)
      console.log(`[${chalk.green(path)}] FOD prefetching successful`)
    }

    lockfile[attr_path].deps.npmHash = await prefetch_FOD('-A', `${attr_path}.browser.passthru.npmDeps`)

    console.log(chalk.green(`[${attr_path}] Done updating ${attr_path} from ${version_nixpkgs} to ${version_upstream}!`))
  }
}


async function fetch_gn(chromium_rev, gn_previous) {
  const DEPS_file = await get_gitiles_file('https://chromium.googlesource.com/chromium/src', chromium_rev, 'DEPS')
  const { rev } = /^\s+'gn_version': 'git_revision:(?<rev>.+)',$/m.exec(DEPS_file).groups

  const cache_hit = rev === gn_previous.rev;
  if (cache_hit) {
    return gn_previous
  }

  const commit_date = await get_gitiles_commit_date('https://gn.googlesource.com/gn', rev)
  const version = `0-unstable-${commit_date}`

  const expr = [`(import ./. {}).gn.override { version = "${version}"; rev = "${rev}"; hash = ""; }`]
  const derivation = await $nixpkgs`nix-instantiate --expr ${expr}`

  return {
    version,
    rev,
    hash: await prefetch_FOD(derivation),
  }
}


async function get_gitiles_commit_date(base_url, rev) {
  const url = `${base_url}/+/${rev}?format=json`
  const response = await (await fetch(url)).text()
  const json = JSON.parse(response.replace(`)]}'\n`, ''))

  const date = new Date(json.committer.time)
  return date.toISOString().split("T")[0]
}


async function fetch_chromedriver_binaries(version) {
  // https://developer.chrome.com/docs/chromedriver/downloads/version-selection
  const prefetch = async (url) => {
    const expr = [`(import ./. {}).fetchzip { url = "${url}"; hash = ""; }`]
    const derivation = await $nixpkgs`nix-instantiate --expr ${expr}`
    return await prefetch_FOD(derivation)
  }

  // if the URL ever changes, the URLs in the chromedriver derivations need updating as well!
  const url = (platform) => `https://storage.googleapis.com/chrome-for-testing-public/${version}/${platform}/chromedriver-${platform}.zip`
  return {
    version,
    hash_darwin: await prefetch(url('mac-x64')),
    hash_darwin_aarch64: await prefetch(url('mac-arm64')),
  }
}


async function chromium_resolve_tag_to_rev(tag) {
  const url = `https://chromium.googlesource.com/chromium/src/+/refs/tags/${tag}?format=json`
  const response = await (await fetch(url)).text()
  const json = JSON.parse(response.replace(`)]}'\n`, ''))
  return json.commit
}


async function resolve_DEPS(depot_tools_checkout, chromium_rev) {
  const { stdout } = await $`./depot_tools.py ${depot_tools_checkout} ${chromium_rev}`
  const deps = JSON.parse(stdout)
  return Object.fromEntries(Object.entries(deps).map(([k, { url, rev, hash }]) => [k,  { url, rev, hash }]))
}


async function get_latest_chromium_release(platform) {
  const url = `https://versionhistory.googleapis.com/v1/chrome/platforms/${platform}/channels/stable/versions/all/releases?` + new URLSearchParams({
    order_by: 'version desc',
    filter: 'endtime=none,fraction>=0.5'
  })

  const response = await (await fetch(url)).json()
  return response.releases[0].version
}


async function get_latest_ungoogled_release() {
  const ungoogled_tags = await (await fetch('https://api.github.com/repos/ungoogled-software/ungoogled-chromium/tags')).json()
  const chromium_releases = await (await fetch('https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/stable/versions/all/releases')).json()
  const chromium_release_map = chromium_releases.releases.map((x) => x.version)
  return ungoogled_tags.find((x) => chromium_release_map.includes(x.name.split('-')[0])).name
}


async function fetch_ungoogled(rev) {
  const expr = (hash) => [`(import ./. {}).fetchFromGitHub { owner = "ungoogled-software"; repo = "ungoogled-chromium"; rev = "${rev}"; hash = "${hash}"; }`]
  const hash = await prefetch_FOD('--expr', expr(''))

  const checkout = await $nixpkgs`nix-build --expr ${expr(hash)}`
  const checkout_path = checkout.stdout.trim()

  await fs.copy(path.join(checkout_path, 'flags.gn'), './ungoogled-flags.toml')

  const chromium_version = (await fs.readFile(path.join(checkout_path, 'chromium_version.txt'))).toString().trim()

  console.log(`[ungoogled-chromium] ${chalk.green(rev)} patch revision resolves to chromium version ${chalk.green(chromium_version)}`)

  return {
    rev,
    hash,
    chromium_version,
  }
}


function version_greater_than(greater, than) {
  return greater.localeCompare(than, undefined, { numeric: true, sensitivity: 'base' }) === 1
}


async function get_gitiles_file(repo, rev, path) {
  const base64 = await (await fetch(`${repo}/+/${rev}/${path}?format=TEXT`)).text()
  return Buffer.from(base64, 'base64').toString('utf-8')
}


async function fetch_depot_tools(chromium_rev, depot_tools_previous) {
  const depot_tools_rev = await get_gitiles_file('https://chromium.googlesource.com/chromium/src', chromium_rev, 'third_party/depot_tools')
  const hash = depot_tools_rev === depot_tools_previous.rev ? depot_tools_previous.hash : ''
  return await prefetch_gitiles('https://chromium.googlesource.com/chromium/tools/depot_tools', depot_tools_rev, hash)
}


async function prefetch_gitiles(url, rev, hash = '') {
  const expr = () => [`(import ./. {}).fetchFromGitiles { url = "${url}"; rev = "${rev}"; hash = "${hash}"; }`]

  if (hash === '') {
    hash = await prefetch_FOD('--expr', expr())
  }

  const { stdout } = await $nixpkgs`nix-build  --expr ${expr()}`

  return {
    url,
    rev,
    hash,
    out: stdout.trim(),
  }
}


async function prefetch_FOD(...args) {
  const { stderr } = await $nixpkgs`nix-build ${args}`.nothrow()
  const hash = /\s+got:\s+(?<hash>.+)$/m.exec(stderr)?.groups?.hash

  if (hash == undefined) {
    throw new Error(chalk.red('Expected to find hash in nix-build stderr output:') + stderr)
  }

  return hash
}
