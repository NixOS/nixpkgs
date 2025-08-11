# Deno Custom Fetcher

## "import from lock file" feature

It's currently not feasible to have an "import from lock file" functionality.

There are several technical problems, that make it currently impossible to build the
dependencies without a hash provided in nix:

1. Files from `x-typescript-types` headers are not listed in the lock file.
1. The necessity in nixpkgs to split the "fetch FOD" from the "file transformation step", makes it impossible,
   since we need to record the headers in a separate FOD and then transform the files in the another derivation using that information.
   Since there is no information in the lock file about the headers, we have to copy the headers information to `$out` of the FOD,
   which changes the hash, so we can't use the hashes from the lock file for all the fetches where we need to record the headers.
1. JSR's API architecture requires us to create a FOD per file of a dependency (not per package, like NPM).
   This provides great granular caching, but terrible performance when fetching, since the disc IO
   quickly gets out of hand, with big JSR packages with hundreds of files.

On top of that, this feature would require a complete reimplementation of all the fetching logic in Nix,
which is a lot of effort, due to its complexity.
And the maintenance effort would double, which is not desirable, since Deno's dependency cache API is still unstable.

## Formats

This section documents what formats the
Deno CLI uses for its dependency directories at the time of writing.

Since many of the formats are considered an implementation detail
by the Deno maintainers, they are subject to change and compatibility
to the Deno CLI can break any time.

Within a year, a couple of upstream changes can be expected.

### Deno version

At the time of writing:

```sh
$ deno --version
deno 2.3.5 (stable, release, x86_64-unknown-linux-gnu)
v8 13.7.152.6-rusty
typescript 5.8.3
```

### `deno.lock`

`deno.lock` version 5

```json
{
  "version": "5",
  "specifiers": {
    "jsr:@luca/cases@1.0.0": "1.0.0",
    "jsr:@std/CLI@1.0.17": "1.0.17",
    "npm:cowsay@1.6.0": "1.6.0"
  },
  "jsr": {
    "@luca/cases@1.0.0": {
      "integrity": "b5f9471f1830595e63a2b7d62821ac822a19e16899e6584799be63f17a1fbc30"
    },
    "@std/CLI@1.0.17": {
      "integrity": "e15b9abe629e17be90cc6216327f03a29eae613365f1353837fa749aad29ce7b"
    }
  },
  "npm": {
    "color-convert@2.0.1": {
      "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
      "dependencies": [
        "color-name"
      ]
    },
    "color-name@1.1.4": {
      "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA=="
    },
    "cowsay@1.6.0": {
      "integrity": "sha512-8C4H1jdrgNusTQr3Yu4SCm+ZKsAlDFbpa0KS0Z3im8ueag+9pGOf3CrioruvmeaW/A5oqg9L0ar6qeftAh03jw==",
      "dependencies": [
        "get-stdin",
        "string-width@2.1.1",
        "strip-final-newline",
        "yargs"
      ],
      "bin": true
    },
    ...
  },
  "redirects": {
    "https://esm.sh/@opentelemetry/api@^1.4.0?target=denonext": "https://esm.sh/@opentelemetry/api@1.9.0?target=denonext",
    ...
  }
  "remote": {
    "https://deno.land/x/case@2.2.0/mod.ts": "28b0b1329c7b18730799ac05627a433d9547c04b9bfb429116247c60edecd97b",
    "https://deno.land/x/case@2.2.0/upperFirstCase.ts": "b964c2d8d3a85c78cd35f609135cbde99d84b9522a21470336b5af80a37facbd",
    "https://deno.land/x/case@2.2.0/vendor/nonWordRegexp.ts": "c1a052629a694144b48c66b0175a22a83f4d61cb40f4e45293fc5d6b123f927e"
    ...
  },
  "workspace": {
    "dependencies": [
      "jsr:@luca/cases@1.0.0",
      "jsr:@std/CLI@1.0.17",
      "npm:cowsay@1.6.0"
    ]
  }
}
```

The 3 sections: `jsr`, `npm` and `remote` represent
[the 3 different kinds of dependencies that Deno supports](https://docs.deno.com/runtime/fundamentals/modules/#importing-third-party-modules-and-libraries).
The packages listed in `remote` are called
[HTTPS imports](https://docs.deno.com/runtime/fundamentals/modules/#https-imports).

### JSR Packages

A JSR package is fetched from the [JavaScript registry](https://jsr.io/).

The basic structure of their API is outlined [here](https://jsr.io/docs/api#jsr-registry-api).
There are multiple steps to fetch a package from the JSR.

1. Fetch the `meta.json` file and look at available versions of a package.
2. Pick a version and fetch the `<version>_meta.json` file and look at the module graph of files, that the package contains.
3. Fetch the relevant files.

#### `meta.json`

**URL**: `https://jsr.io/@<scope>/<package-name>/meta.json`

**Format**:

```json
{
  "scope": "luca",
  "name": "flag",
  "versions": {
    "1.0.0": {
      "yanked": true
    },
    "1.0.1": {}
  }
}
```

These files are mutable and change as new versions appear.
Therefore, we should not fetch them in a FOD.

The Deno CLI requires these files, however, so we need to construct them from
the information we get from the lock file.

Since the same package can occur multiple times in the lock-file, with different versions,
we have make sure, that for each version, there is an entry in `.versions`.

#### `<version>_meta.json`

**URL**: `https://jsr.io/@<scope>/<package-name>/<version>_meta.json`

**Format**:

```json
{
  "manifest": {
    "/deno.json": {
      "size": 75,
      "checksum": "sha256-98719bf861369684be254b01f1427084dc6d16b506809719122890784542496b"
    },
    "/LICENSE": {
      "size": 1070,
      "checksum": "sha256-c3f0644e8374585b209ea5206ab88055c1c503c202bff5d1f01bb29c07041fbb"
    },
    "/README.md": {
      "size": 279,
      "checksum": "sha256-f544a1489e93e93957d6bd03f069e0db7a9bef4af6eeae46a86b4e3316e598c3"
    },
    "/main.ts": {
      "size": 2989,
      "checksum": "sha256-a41796ceb0be1bca3aa446ddebebcd732492ccb2cdcb8912adbabef3375fafc8"
    }
  },
  "moduleGraph1": {
    "/main.ts": {}
  },
  "exports": {
    ".": "./main.ts"
  }
}
```

but the module graph can also look like this:

<details>

<summary> Module Graph </summary>

```json
{
  "moduleGraph2": {
    "/prompt_secret.ts": {},
    "/nested/twice/unicode_width.ts": {
      "dependencies": [
        {
          "type": "static",
          "kind": "import",
          "specifier": "./_data.json",
          "specifierRange": [ ... ],
          "importAttributes": {
            "known": {
              "type": "json"
            }
          }
        },
        {
          "type": "static",
          "kind": "import",
          "specifier": "../../_run_length.ts",
          "specifierRange": [ ... ]
        },
        {
          "type": "static",
          "kind": "import",
          "specifier": "npm:preact@^10.25.1",
          "specifierRange": [ ... ]
        },
        {
          "type": "static",
          "kind": "importType",
          "specifier": "./runtime/server/mod.ts",
          "specifierRange": [ ... ]
        },
        {
          "type": "dynamic",
          "argument": "npm:esbuild-wasm@0.23.1",
          "argumentRange": [ ... ]
        },
        {
          "type": "dynamic",
          "argument": [
            {"type":"string","value":"npm:esbuild-wasm@0.23.1"},
            {"type":"string","value":""}
          ],
          "argumentRange": [ ... ]
        },
      ]
    },
    "/mod.ts": {
      "dependencies": [
        {
          "type": "static",
          "kind": "export",
          "specifier": "./parse_args.ts",
          "specifierRange": [ ... ]
        },
        {
          "type": "static",
          "kind": "export",
          "specifier": "./prompt_secret.ts",
          "specifierRange": [ ... ]
        },
        {
          "type": "static",
          "kind": "export",
          "specifier": "./spinner.ts",
          "specifierRange": [ ... ]
        },
        {
          "type": "static",
          "kind": "export",
          "specifier": "./unicode_width.ts",
          "specifierRange": [ ... ]
        }
      ]
    },
    "/parse_args.ts": {},
    "/_run_length.ts": {},
    "/spinner.ts": {}
  }
}
```

</details>

These files are immutable. JSR promises they will never change.

The integrity hashes in the lock file are made from the `<version>_meta.json`
files, so we can use them to construct FODs containing the `<version>_meta.json` files.

From there we can parse the module graph and construct a list of the files we need.

#### The actual package files

**URL**: `https://jsr.io/@<scope>/<package-name>/<version>/<file_path>`

Since the files in `.manifest` associate paths and integrity hashes,
we can construct a list of `(url, hash)` pairs, from which we can construct FODs.

To reduce the amount of fetched files, we can parse the moduleGraph.

Required files can occur in multiple places:

- importers: the keys of `.moduleGraph{1,2}`,
- imported: the values of `.moduleGraph{1,2}.<path>.depedencies[i].{specifier,argument}`
- exporters: the values of `.exports`

By combining those three lists and making entries unique, we can create a list of all the
required files, and only those. Mind that the values in `imported` use relative paths,
so we need Unix path resolution logic to resolve those to absolute URLs, to fetch from.

Like this we can fetch all necessary resources from the JSR, using just the information
in the lock file, without needing to specify a hash in Nix.

### HTTPS Packages

Deno supports 3 different JavaScript CDNs:

- `deno.land/x`
- `esm.sh`
- `unpkg.com`

For HTTPS Packages, generally, the lock file already lists the resolved URLs for us and
associates them with the hashes of the files.

There are some caveats to this, though.

In the lock-file, it is possible, that a required URL only occurs in the values of `.redirects`,
and not in the keys of `.remote`.

I specifically observed this, [here](https://github.com/iv-org/invidious-companion/blob/d0c4bb79ae4688d019fb281257859e334adb7d8b/deno.lock#L431).
This is probably related to the fact that an import from `esm.sh/@types/...` can be used by NPM packages in `.dependencies` as `npm:@types/...`.
And this might not only be true for `esm.sh` or `@types`.

That means generally the URLs for fetching should be obtained from a unique list of
the values of `.redirects` and the keys of `.remote`.

It also means, it is possible to not have no hash from the lock-file
for some URLs.

#### `esm.sh`

##### Extra query parameter

Deno implicitly appends the query parameter `?target=denonext` to `esm.sh` URLs,
if there is not already another `?target=` query parameter in the URL.

We have to do the same, when we fetch the files.

However, when passing a URL, to the Deno API to construct a vendor directory (see below),
we have to use the original, unchanged URL.

##### Response headers

Also `esm.sh` requests can return a `X-Typescript-Types: <url>` header.

Deno will read this header and fetch the `.d.ts` file at the `<url>` and
add that file to the local cache folder.

Mind that the `<url>` can be a relative path, which then has to be resolved respective to the
URL, the fetch call was made to.

This is unfortunate, since there is no hash for that `.d.ts` file in the lock file.

On top of that, Deno will recursively fetch all imported `.d.ts` files in that
entrypoint-`.d.ts` file.

#### Private HTTPS repositories

Deno supports [private HTTPS repositories](https://docs.deno.com/runtime/fundamentals/modules/#private-repositories)
by associating `Bearer` tokens or `Basic` auth credentials with specific URLs in an
environment variable.

It looks like this:

```sh
DENO_AUTH_TOKENS=a1b2c3d4e5f6@deno.land;f1e2d3c4b5a6@example.com:8080;username:password@deno.land
```

**NOT IMPLEMENTED**: This would require us to somehow get the `(credential, domain)`
pairs and then provide all `curl` calls to the respective domain with the respective auth headers.

### Vendor directory

Both the JSR and HTTPS packages end up in the vendor directory, if the `--vendor`
flag is used or the `"vendor": true` option is set in `deno.json`.

This build helper uses the vendor directory, since it provides a much better
interface compared to not using it.

#### File renaming scheme

Generally, Deno maps the paths from the file URLs directly to paths in the vendor directory.
However, for cross-platform compatibility, Deno uses a **custom file renaming scheme**,
if file names use problematic characters.

This scheme is currently implemented in rust and can be found
[here (version at the time of writing)](https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L557).

There is a JavaScript and Rust wrapper library for it in the same repository, [available
at JSR](https://jsr.io/@deno/cache-dir/doc/~/HttpCache.prototype.set).

It exposes these functions

```typescript
HttpCache.create(options: {
    root: string, // $DENO_DIR
    vendorRoot: string, // vendor
    readOnly: boolean,
}): Promise<HttpCache>

HttpCache.prototype.set(
    url: url,
    headers: Record<string, string>,
    content: Uint8Array,
): void
```

We use these functions from Rust to construct the vendor directory.
We just need to pass tuples of `(url, headers, file_content)` to the function,
where `url` is the original URL used to fetch the file, `headers` are the response headers for that fetch,
and `file_content` is read from our fetched files from the Nix store.

#### `manifest.json`

On top of that, in the `vendor` directory, there is a `manifest.json`.

**Target Location:**
`vendor/manifest.json`

**Format:**

```json
{
  "modules": {
    "https://deno.land/x/case@2.2.0/camelCase.ts": {},
    "https://deno.land/x/case@2.2.0/constantCase.ts": {},
    "https://deno.land/x/case@2.2.0/dotCase.ts": {},
    ...
    "https://esm.sh/cowsay@1.6.0": {
      "headers": {
        "content-type": "application/javascript; charset=utf-8",
        "x-typescript-types": "https://esm.sh/cowsay@1.6.0/index.d.ts"
      }
    },
    "https://jsr.io/@std/CLI/1.0.17/unstable_progress_bar_stream.ts": {},
    "https://jsr.io/@std/CLI/1.0.17/unstable_prompt_multiple_select.ts": {}
  }
}
```

This file plays a role in this renaming scheme. It records some response headers
of fetched files. Without the correct response headers in this file,
the files won't be recognized by the Deno CLI.

The relevant headers are listed in the rust code
[here (version at the time of writing)](https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802).

This poses a problem for this build helper,
since we need to acquire those response headers in a FOD and copy them to `$out`,
so we can use them later. However, the hashes we have from the lock file are just
for the files themselves, not for the response headers.

From my testing, the response headers only occurred for HTTPS packages.

This means for HTTPS packages, we can't use the hashes from the lock file, but
instead have to **create a FOD with a hash given in Nix**.

The `manifest.json` file itself is also created by the `HttpCache.prototype.set(...)` function mentioned above.
But as we saw now, it is important that we provide it the relevant response headers.

## NPM Packages

Deno also supports the NPM registry.

### Package `tarball`

From the package specifier we can construct the URL for a package's tarball and
using the hash given in the lock file, we can fetch it in a FOD.

**URL**:

- `https://registry.npmjs.org/<name>/-/<name>-<version>.tgz`
- `https://registry.npmjs.org/@<scope>/<name>/-/<name>-<version>.tgz`

**Target Location**:

- `$DENO_DIR/npm/registry.npmjs.org/<name>/<version>`
- `$DENO_DIR/npm/registry.npmjs.org/@<scope>/<name>/<version>`

We need to extract the tarballs to the correct target location, so Deno can find
the files.

### `registry.json`

Deno uses a subset of the JSON file located at the following URL at the NPM registry
and calls it `registry.json`.

Deno requires this file to be present for all NPM packages.

**URL**:

- `https://registry.npmjs.org/<name>`
- `https://registry.npmjs.org/@<scope>/<name>`

**Format**:

Deno's `registry.json` file

```json
{
  "name": "cowsay",
  "versions": {
    "1.0.3": {
      "version": "1.0.3",
      "dist": {
        "tarball": "https://registry.npmjs.org/cowsay/-/cowsay-1.0.3.tgz",
        "shasum": "ae30666aa6d82e839fb6628845b57ecd3697a8d7",
        "integrity": "sha512-3M5mjbV1phkc2OyZZ917dYa2lCPiNe+BolVq4ds0lhLCXMLKWJ7vWE8XvnPJuKcsao0T3sAdfLOPPCVD8NBQxQ=="
      },
      "bin": {
        "cowthink": "./CLI.js",
        "cowsay": "./CLI.js"
      },
      "dependencies": {
        "optimist": "~0.3.5"
      },
      "scripts": {
        "test": "node test.js"
      }
    }
  },
  "dist-tags": {
    "latest": "1.6.0"
  },
  "_deno.etag": "W/\"e7a4c9e49be6835f2c004a684f945280\""
}
```

**Target Location**:

- `$DENO_DIR/npm/registry.npmjs.org/<name>/registry.json`
- `$DENO_DIR/npm/registry.npmjs.org/@<scope>/<name>/registry.json`

Those files are mutable. They have a `.version` field, which holds the currently available versions of a package.
So instead of fetching that file, we have to construct it from the available information.

Like with the `meta.json` file, we have make sure,
that for each version a package occurs in the lock-file, there is an entry in `.versions`.

Fortunately, Deno doesn't need all the fields or the information in them,
so we can put empty values for some and omit the field altogether for others.

Finally, we need to make sure we put the file at the correct target location, so
Deno can find it.

### `node_modules` directory

The `deno.json` option
[`nodeModulesDir`](https://docs.deno.com/runtime/fundamentals/node/#node_modules)
and the CLI flag
[`--allow-scripts`](https://docs.deno.com/runtime/reference/CLI/add/#options-allow-scripts)
together enable a feature of NPM called [`lifecycle scripts`](https://docs.npmjs.com/CLI/v6/using-npm/scripts#life-cycle-operation-order).

Specifically there is a lifecycle script called `postinstall`, which triggers
after a package has been installed and enables that package to perform an
arbitrary operation on the users machine, like downloading external dependencies.

Deno constructs its own version of a `node_modules` directory,
to be compatible with the NPM lifecycle scripts.

**NOT IMPLEMENTED**: This would require us constructing the `node_modules` directory,
possibly with a rust library used by Deno:

- <https://docs.rs/deno_npm_cache/0.28.0/deno_npm_cache/>
- <https://docs.rs/deno_npm/0.35.0/deno_npm/>

And then creating a FOD and executing the lifecycle script in there,
which will require a hash in Nix.

### Custom NPM registries and `.npmrc`

NPM supports a configuration file called
[`.npmrc`](https://docs.npmjs.com/CLI/v8/configuring-npm/npmrc).

It enables the user to associate a `@scope` with a custom URL, and associate that URL with an auth token.

```ini
@myscope:registry=https://mycustomregistry.example.org
//mycustomregistry.example.org/:_authToken=MYTOKEN
```

**NOT IMPLEMENTED**: This would require us parsing the `.npmrc` file.
Then we need to extract the `(@scope, domain)` pairs.
Then we need to adapt the construction of NPM URLs for the relevant scopes.
And then provide all `curl` calls to the respective domain with the respective auth headers.

### `@ts-types`, triple slash directive and `deno.json`'s `compilerOption.types`

[`@ts-types`](https://docs.deno.com/runtime/reference/ts_config_migration/#providing-types-when-importing)
formerly called `@deno-types`, is an annotation that can be made above import
statements in js code.

The
[triple slash directive](https://docs.deno.com/runtime/reference/ts_config_migration/#triple-slash-directive)
can be placed in `.d.ts` files and can also import types.


[`deno.json`'s `compilerOption.types`](https://docs.deno.com/runtime/reference/ts_config_migration/#supplying-%22types%22-in-deno.json)
is a list of `packageSpecifier`s that can be placed
files to import types as well.

These imported files can be any `packageSpecifier`, so absolute or relative
paths, as well as `https://`, `jsr:` and `npm:` specifiers.

(although I did no testing with `jsr:` packages, since there were no extra types on jsr as packages)

Deno will download these files lazily, only when type checking was triggered
with e.g. `deno check` or `deno compile`.

If developers don't do that locally, the files won't be added to the lock-file,
but type checking during build will still fail, as Deno will try to download the
missing types file.

`https://` specifiers don't get added to the lock-file, even if they are
downloaded while developing.

This leaves us with the problem that sometimes such a specifier is not part of the
lock-file, but the fetcher already needs to know about them.

We could pass the entire source files along with the lock file to the fetcher,
but this creates problems with the updating of the hash.

There is a check in the `buildDenoPackage` that tells the user that the lock
file has changed and they need to update the `denoDepsHash`, which will then
result in a refetch.

Doing the same thing for the whole source code would mean refetching on every
code change while developing.

Instead, what we need is another derivation, before the fetching step, that
takes the source files as input and returns a JSON containing all the
_hidden_ `packageSpecifiers` in the source code.
This JSON is passed to the `lockfile-transformer` and the
`packageSpecifiers` in it are merged with the specifiers from the lock-file.
The JSON is also passed to the fetcher and the fetcher copies it to `$out`.
The JSON in the fetcher derivation can then be checked every time when
building and, if it changes, the user needs to update the `denoDepsHash`.

**NOT IMPLEMENTED**: These all these `packageSpecifier`s can be written without a version.
This does not matter for `https:` case, since those are fetched as is,
but for the `jsr:` and `npm:` case, we need to construct a URL from the package specifier
and to do that we need a version.
NPM and JSR offer discovery mechanisms to discover the latest version from their API,
but we can't do that, since the latest version is mutable.
We would have to do this in the fetcher-step and depending on the latest version of a types file,
the whole hash of the fetcher derivation could change, which would break reproducibility
and cause unnecessary rebuilds.
So this build helper requires there to be a version for the `jsr:` and `npm:` cases.
