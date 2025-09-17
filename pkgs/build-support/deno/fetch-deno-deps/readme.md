# Deno Custom Fetcher

This goal of this file is to make the code maintainable.

Deno's dependency cache API is very complex and obscure. It requires a lot of
research and some reverse engineering to figure it all out.

Also Nixpkgs imposes some complicated constraints on the design of our code,
which are not trivially understood, nor well documented at the time of writing.

So to understand why the code is the way it is, a maintainer should read this whole file first,
and use it as a reference later.

## Formats

This section documents what formats the Deno CLI uses for its dependency
cache at the time of writing.

It's assumed that the reader knows:

- what Deno is
- how Deno's packaging works, roughly
- what Nix and Nixpkgs is
- what the purpose of a language build helper in Nixpkgs is
- what Fixed Output Derivations (FODs) are,
  and why they are a necessity for language build helpers


Since many of the formats are considered an implementation detail by the Deno
maintainers, they are subject to change and compatibility to the Deno CLI can
break any time.

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

**Format**:

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

The basic structure of their API is outlined
[here](https://jsr.io/docs/api#jsr-registry-api).
Multiple steps are necessary, to fetch a package from the JSR.

1. Fetch the `meta.json` file and look at available versions of a package.
2. Pick a version and fetch the `<version>_meta.json` file and analyse at the
   module graph of files, that the package contains.
3. Fetch the relevant files individually.

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

**Implementation Notes**: These files are mutable and change as new versions appear.
Therefore, we should not add them to the output of an FOD.

The Deno CLI requires these files, however, so we need to construct them from
the information we get from the lock file.

Since we are not fetching the files, but constructing them, we don't need an
integrity hash for them.

Another thing to consider is, that the same package can occur multiple times in
the lock-file with different versions. So we have to make sure, that for each
version, there is an entry in `.versions`.

This requires us to have some logic, which collects the versions of a package.

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

**Implementation Notes**: These files are immutable. JSR promises they will never change.

The integrity hashes for JSR packages in the lock-file, are sha256 hashes over
the contents of the `<version>_meta.json` files.

The Deno CLI also expects to find the `<version>_meta.json` files, so we need to
keep them.

To get the actual package files we need to parse the module graph and extract a
list of the files.

#### The actual package files

**URL**: `https://jsr.io/@<scope>/<package-name>/<version>/<file_path>`

**Implementation Notes**: We get the integrity hashes per file from `.manifest`.

To reduce the amount of fetched files, we should parse the `moduleGraph`.

Required files can occur in multiple places:

- importers: the keys of `.moduleGraph{1,2}`,
- imported: the values of
  `.moduleGraph{1,2}.<path>.depedencies[i].{specifier,argument}`
- exported: the values of `.exports`

By combining those three lists and making entries unique, we can create a list
of all the required files, and only those.

Mind that the values in `imported` use relative paths, so we need Unix path
resolution logic to resolve those to absolute URLs, to fetch from.

Also note, that dynamic imports can contain full package specifiers like
`npm:esbuild-wasm@0.23.1`. We assume that those were added to the lock-file, so
we just skip them when constructing our file list.

### HTTPS Packages

Deno supports JavaScript CDNs like:

- `deno.land/x`
- `esm.sh`
- `unpkg.com`

**Implementation Notes**: For HTTPS Packages, generally,
the lock file already lists the resolved URLs for
us in `.remote` and associates them with the hashes of the files.

There are some caveats to this, though.

In the lock-file, it is possible, that a required URL only occurs in the values
of `.redirects`, and not in the keys of `.remote`.

I specifically observed this,
[here](https://github.com/iv-org/invidious-companion/blob/d0c4bb79ae4688d019fb281257859e334adb7d8b/deno.lock#L431).
This is probably related to the fact that an import from `esm.sh/@types/...` can
be used by NPM packages in `.dependencies` as `npm:@types/...`.

Since this can presumably only occur for type files, and we don't consider type
files (see [below](#type-files)), we don't need to worry about that.

#### `esm.sh`

Deno implicitly appends the query parameter `?target=denonext` to `esm.sh` URLs,
if there is not already another `?target=` query parameter in the URL.

**Implementation Notes**: We have to do the same, when we fetch the files.

However, when passing a URL, to the Deno API to construct a vendor directory
(see [below](#vendor-directory)), we have to use the original, unchanged URL.

#### Private HTTPS repositories

Deno supports
[private HTTPS repositories](https://docs.deno.com/runtime/fundamentals/modules/#private-repositories)
by associating `Bearer` tokens or `Basic` auth credentials with specific URLs in
an environment variable.

It looks like this:

```sh
DENO_AUTH_TOKENS=a1b2c3d4e5f6@deno.land;f1e2d3c4b5a6@example.com:8080;username:password@deno.land
```

**Not implemented**: This would require us to somehow get the
`(credential, domain)` pairs and then provide all `curl` calls to the respective
domain with the respective auth headers.

### Vendor directory

Both the JSR and HTTPS packages end up in the vendor directory, if the
`--vendor` flag is used or the `"vendor": true` option is set in `deno.json`.

**Implementation Notes**: This build helper uses the vendor directory,
since it provides a much better interface compared to not using it.

#### File renaming scheme

Generally, Deno maps the paths from the file URLs directly to paths in the
vendor directory. However, for cross-platform compatibility, Deno uses a
**custom file renaming scheme**, if file names use problematic characters.

This scheme is currently implemented in Rust and can be found
[here (version at the time of writing)](https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L557).

**Implementation Notes**:

There is a JavaScript and Rust wrapper library for it in the same repository,
[available at JSR](https://jsr.io/@deno/cache-dir/doc/~/HttpCache.prototype.set).

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

We use these functions from Rust to construct the vendor directory. They expect
tuples of `(url, headers, file_content)`, where `url` is the original URL used
to fetch the file, `headers` are the response headers for that fetch, and
`file_content` is read from our fetched files from the Nix store.

We use them from Rust and not from JavaScript, because we don't have a way to
package a Deno package with dependencies, except for the very build helper we
are building here, which we can't use (chicken-egg-problem)

#### `manifest.json`

On top of that, in the `vendor` directory, there is a `manifest.json`.

**Target Location:** `vendor/manifest.json`

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
of fetched files. Without the correct response headers in this file, the files
won't be recognized by the Deno CLI.

The relevant headers are listed in the rust code
[here (version at the time of writing)](https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802).

**Implementation Notes**: The `manifest.json` file itself is also created by the
`HttpCache.prototype.set(...)` function mentioned above. But as we saw now, it
is important that we provide it the relevant response headers.

### NPM Packages

Deno also supports the NPM registry.

#### Package `tarball`

From the package specifier we can construct the URL for a package's tarball and
using the hash given in the lock file, we can fetch it in a FOD.

**URL**:

- `https://registry.npmjs.org/<name>/-/<name>-<version>.tgz`
- `https://registry.npmjs.org/@<scope>/<name>/-/<name>-<version>.tgz`

**Target Location**:

- `$DENO_DIR/npm/registry.npmjs.org/<name>/<version>`
- `$DENO_DIR/npm/registry.npmjs.org/@<scope>/<name>/<version>`

**Implementation Notes**: We need to extract the tarballs to the correct target location,
so Deno can find the files.

#### `registry.json`

Deno uses a subset of the JSON file located at the following URL at the NPM
registry and calls it `registry.json`.

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

**Implementation Notes**: Those files are mutable. They have a `.version` field,
which holds the currently available versions of a package.
So instead of fetching that file, we have to construct it from the available information.

Like with the `meta.json` file, we have to make sure, that for each version a
package occurs in the lock-file, there is an entry in `.versions`.

Fortunately, Deno doesn't need all the fields or the information in them, so we
can put empty values for some and omit the field altogether for others.

Finally, we need to make sure, we put the file at the correct target location,
so Deno can find it.

#### `node_modules` directory

The `deno.json` option
[`nodeModulesDir`](https://docs.deno.com/runtime/fundamentals/node/#node_modules)
and the CLI flag
[`--allow-scripts`](https://docs.deno.com/runtime/reference/CLI/add/#options-allow-scripts)
together enable a feature of NPM called
[`lifecycle scripts`](https://docs.npmjs.com/CLI/v6/using-npm/scripts#life-cycle-operation-order).

Specifically there is a lifecycle script called `postinstall`, which triggers
after a package has been installed and enables that package to perform an
arbitrary operation on the users machine, like downloading external
dependencies.

Deno constructs its own version of a `node_modules` directory, to be compatible
with the NPM lifecycle scripts.

**Not implemented**: This would require us constructing the `node_modules`
directory, possibly with a rust library used by Deno:

- <https://docs.rs/deno_npm_cache/0.28.0/deno_npm_cache/>
- <https://docs.rs/deno_npm/0.35.0/deno_npm/>

And then creating a FOD and executing the lifecycle script in there, which will
require a hash in Nix.

#### Custom NPM registries and `.npmrc`

NPM supports a configuration file called
[`.npmrc`](https://docs.npmjs.com/CLI/v8/configuring-npm/npmrc).

It enables the user to associate a `@scope` with a custom URL, and associate
that URL with an auth token.

```ini
@myscope:registry=https://mycustomregistry.example.org
//mycustomregistry.example.org/:_authToken=MYTOKEN
```

**Not implemented**: This would require us parsing the `.npmrc` file. Then we
need to extract the `(@scope, domain)` pairs. Also, we need to adapt the
construction of NPM URLs for the relevant scopes. And then provide all fetch
calls to the respective domain with the respective auth headers.

### Type files

Deno supports various methods to add second class dependencies on type files.

They are second class, because usually they are

- not added to the `deno.json` file or the lock-file
- missing an integrity hash
- lazily fetched, only when running `deno check` or `deno compile`, not when
  running `deno install`
- only evaluated when running `deno check` or `deno compile`

I made multiple issues in Deno repos upstream, but it appears this is by design.

- <https://github.com/denoland/deno_graph/issues/594>
- <https://github.com/denoland/deno/issues/30375>

Also see this issue, which points out inconsistencies and bugs around this type
import system.

- <https://github.com/denoland/deno/issues/30406>

**Not implemented**: As you will see, fetching all those type files is generally very complicated.

To keep things simple, we add the `--no-check` flag to our `deno compile`
command, which will skip fetching and evaluation of the type files entirely.

This means, this build helper does not generally support type checks.

#### Inline type imports

With these two Deno features, users can specify type imports inside code
comments:

- [@ts-types/@deno-types](https://docs.deno.com/runtime/reference/ts_config_migration/#providing-types-when-importing)
- [triple slash directive](https://docs.deno.com/runtime/reference/ts_config_migration/#triple-slash-directive)

The imports are generally not added to the lock-file.

There are exceptions:

- NPM type packages are added to the lock-file, like regular NPM packages
- HTTPS URLs are added to `.redirects`, if they are redirected

**Not implemented**: To find the imports, we would need to parse, or at least grep all the source
code, and possibly all the source code of dependencies and fetch the type
dependencies.

Also type files can generally import other type files, so we would need to
recursively parse and fetch imports in the type files to construct a complete
dependency graph. This gets very complicated, since the same type files can also
be imported multiple times in the dependency graph, by different other files. So
we would also need some deduplication, which is not trivial, since we want to
run our fetch calls asynchronously for performance reasons.

Also, at this point grepping with regex is not good enough any longer, since
there will be false positives and false negatives, if we don't properly parse
the TypeScript files.

Looking at the Nix side, to not create another FOD, we would need a derivation,
that does the code analysis and extracts URLs, which are then passed to the
fetcher.

#### Type import in `deno.json`

With this Deno feature, users can specify type imports inside `deno.json`, but
not in the dependency section.

- [deno.json's compilerOption.types](https://docs.deno.com/runtime/reference/ts_config_migration/#supplying-%22types%22-in-deno.json)

**Not implemented**: In this case, we don't need to parse the entire source code, but just the
`deno.json`, which is much easier. However all the other problems mentioned
above remain.

#### Response headers

Deno generally supports fetching types for HTTPS dependencies via a
[`X-Typescript-Types: <url>` response header](https://docs.deno.com/runtime/fundamentals/typescript/#providing-types-for-http-modules).

In my testing, only `esm.sh` supported this feature.

Deno will read this header and fetch the `.d.ts` file at the `<url>` and add
that file to the local cache folder.

Deno will recursively fetch all imported `.d.ts` files in that
entrypoint-`.d.ts` file.

The `<url>` can be a relative path, which then has to be resolved respective to
the URL, the fetch call was made to.

**Not implemented**: This method is slightly different from the methods above, since the required
type files will only become known in the fetch step.

The other problems mentioned above remain.

## "import from lock file" feature

**Not implemented**: It's currently not feasible to have an "import from lock file" functionality.

There are several technical problems, that make it currently impractical to
build the dependencies without a hash provided in nix:

1. **Nixpkgs requirements**: The necessity in Nixpkgs to split the "fetch FOD" from
   the "file transformation step", makes it impossible, since we need to record
   the response headers in a separate FOD and then transform the files in the
   another derivation using that information. Since there is no information in
   the lock file about the headers, we have to copy the headers information to
   `$out` of the FOD, which changes the hash, so we can't use the hashes from
   the lock file for all the fetches where we need to record the headers.
1. **Performance**: JSR's API architecture requires us to create a FOD per file of a
   dependency (not per package, like NPM). This provides great granular caching,
   but terrible performance when fetching, since the disc IO quickly gets out of
   hand, with big JSR packages with hundreds of files. I actually tested this,
   and a fetch with many jsr dependencies could really take a few minutes,
   compared to the seconds it takes now.
1. **Nix compatability**: Type file imports (which are not supported anyway, due to
   their complexity) cannot work with this feature, since there are no hashes
   for them in the lock-file, and some type files may only become known in the
   fetch step.
1. **Feasibility**: This feature would require a complete reimplementation of all
   the fetching logic in Nix, which is a lot of effort, due to its complexity.
   And the maintenance effort would double, which is not desirable, since Deno's
   dependency cache API is still unstable.

## Architecture

This section documents the general architecture of the `buildDenoPackage`
language build helper made for Nixpkgs.

It's assumed that the reader knows:

- what Nix and Nixpkgs is
- what the purpose of a language build helper in Nixpkgs is
- what Fixed Output Derivations (FODs) are,
  and why they are a necessity for language build helpers

### Design constraints

Due to the build helper existing in the context of Nixpkgs,
there are a couple of constraints to keep in mind, which are explained in detail below.

We need:
- a **custom fetcher**; we can't use the language's package manager CLI
- to **decouple fetching logic** from the language's package manager formats
  (like lock-file or dependency cache folder)
- to provide an **IFD-free build** method

#### Custom fetcher

A naive implementation of a language build helper could use the
CLI of the language package manager and wrap the installation step in a FOD,
so files can be downloaded, and wrap the build step in a derivation. Done.

However, this approach has caused great problems for Nixpkgs in the past and is
now to be avoided.

The reason is that the package manager CLI version will change,
as it is updated in Nixpkgs and with such a change,
the FOD that was produced by the build helper can change.

This can become a huge problem for Nixpkgs, since FODs use hashes over the output
to find cached results in the Nix store. The hash of a FOD won't change until done manually,
which means, as long as that step is not performed, the cached, outdated version from the Nix store will
be used. A rebuild of the FOD however would now produce a new version with a different hash.

Because the nix cache will hold those FODs potentially for years, there can be a huge
delay until a breaking change in the package manager CLI is recognized, which will make
debugging very difficult.

So, generally speaking, Nixpkgs wants language build helpers to use custom fetchers,
instead of just invoking the language-specific package manager CLI to fetch the packages.

#### Decouple fetching logic

Since FODs generally require manually inserting a hash, it can be a cumbersome
process if done many times.

So custom fetchers should try to require changing hashes of FODs as few times as possible.

To do this, we need to decouple the fetching step from all the other language-specific
logic, so that a change to any format the package manager uses, does not require
a change to the hash of the FOD.

#### Import from derivation (IFD) and "import from lock file" feature

##### What is IFD?

<https://nix.dev/manual/nix/2.23/language/import-from-derivation>

In short, IFD forbids us to **read** a file from a derivation in Nix code.

IFD is forbidden in Nixpkgs due to performance implications.
This means a build helper has to provide an IFD-free build.

So the entire logic to parse the lock file, fetch all dependencies, transform
them into the right format, and finally build the package,
has to be run inside one or multiple derivations.

Or put another way, that **logic cannot be written in the Nix language**, when
aiming for an IFD-free build.

The derivation containing the fetched files, then is an input to the derivation
building the package.

##### What is "import from lock file"?

By default, to fetch anything from the internet in Nixpkgs, you need a fixed output derivation, which
requires an `outputHash` to verify, that the output did not change compared to last time.

For a build helper this means, when we want to download the dependencies of a
package, we need to provide at least one hash.

This is a nuisance, since we need to manually change the hash each time the dependencies change.
For a package maintained in Nixpkgs it does not occur that often, however if the build-helper is used
when developing a package, it does.

Since there are usually integrity hashes for packages in lock files,
we could theoretically just use those, and circumvent having to specify a hash
in Nix.

To do that, we need to parse the lock file in Nix. Mind that this step
implies IFD, if the lock-file is not part of the same repo, but is for example
fetched from a remote repo with `fetchGit`.

With the parsed lock-file, we then create separate FODs
one per `(url, hash)` pair. Also, we need to collect all those FODs and
associate them with enough meta information to enable us to transform them
into a file structure, that the language's package manager will understand.

All the logic to parse the lock-file and fetch the files, **has to be written in Nix**.

Creating many FODs can have serious performance implications, since each FOD
means a new build container and build environment etc. So the disk IO can
become a bottleneck if this goes into the thousands.

##### "Packaging in nixpkgs" vs "packaging while developing"

There are two different user scenarios to consider:

1. Package maintainers in Nixpkgs, that want to package some remote source code
   using the build-helper.

   Since they can't use IFD, they can't just fetch the source code in a build
   and then import that lock file in Nix.

   This usually means, they provide the hash manually.

   Sometimes the remote source code does not have a lock-file.
   Then they have to generate and vendor the lock file in the Nixpkgs repo.

2. Developers, writing their own language package, that want to package their
   local code with Nix using the build-helper.

   Developers usually don't care about IFD, but they do care about the nuisance
   of having to manually change the hash every time they import a new package
   while developing.

##### Summary

So to summarize:

To provide the package maintainers with the functionality they require,
we have to write the entire logic to parse the lock file and fetch the files,
in a way that it can be executed inside a derivation, because of the IFD constraint.
So it can't be written using the Nix language.

And to provide the developers with the functionality they would like,
we have to write the logic in the Nix language.

So we end up with two implementations, doing basically the same thing
but slightly different.

### Abstract approach

As explained in ["import from lock file" feature](#import-from-lock-file-feature),
that feature is not implemented.

So according to our constraints, we end up with this architecture:

![architecture diagram](./builder-architecture.drawio.svg)

As a horizontal line, we see a divide between eval time and build time.

It's important to differentiate here, because everything in eval time,
is written in Nix and everything in build time is executed in a build container,
using some language different from Nix.

Also, whenever we would have data flow from build time to eval time, we would do an IFD.

The separation of the 3 concerns:
1. lock-file transformer
2. fetcher
3. file structure transformer

stems from the first two constraints above:
- [Custom Fetcher](#custom-fetcher)
- [Decouple fetching logic](#decouple-fetching-logic)

Since we want to break FODs as few times as possible, we need to separate the
fetching step from
the lock file parsing step and the file structure transformation step.

To properly decouple the fetching step from `deno.lock`'s format,
we need to introduce our own format, which we have full control over.
I called it `Common Lock Format`.

The file structure transformation step happens during the package build
to avoid having to cache the same files twice, once from step 2 and once from
step 3. This is important to reduce load on the nixpkgs cache servers.

### Concrete implementation

Each of the 3 steps:
1. lock-file transformer
2. fetcher
3. file structure transformer

uses their own scripts and has their own tests.

The tests also act as specifications for the steps.
You can for example look at the `Common Lock Format` in the test cases.

Read more about the tests in `/pkgs/test/build-deno-package/integration-tests/readme.md`

In Deno, we have 3 kinds of dependencies:
- `jsr:`
- `npm:`
- `https:`

and each kind requires special handling in each of the steps.

Because of this, the scripts have separate logic for each kind.

Most of the logic is written in Deno, except for the file structure transformer
for the `vendor/` directory, which is written in Rust to use a specific library
provided by Deno.

Mind that the Deno code **can't import external dependencies**, since we can't
package those with Nix until this build helper exists (chicken-egg-problem).

#### Lock-file transformer

The lock-file transformer needs to transform the `deno.lock` into the
`Common Lock Format`.

The logic is written in a single Deno script.

It creates 3 `Common Lock` files, one per dependency kind, so they don't have
to be separated again in the fetching step.

#### Fetcher

The fetcher is the most complex part of the three.

The logic is written in Deno.

It uses the 3 `Common Lock` files from the previous step, downloads all the
dependencies and adds `outPaths` to the 3 `Common Lock` files.

However, it does not write 3 three files to disk just like that, but combines
`jsr:` and `https:` into `vendor.json` (see next step).

It does not structure the downloaded files whatsoever. Each file is written
to a unique path (using sha256 over the download URL) in the same folder.

The extended `Common Lock` files are written to the same folder.

#### File structure transformer

The file structure transformer has to split a little differently.

1. It has to put the packages from the `jsr:` and `https:` packages in the `vendor/` directory.
1. And it has to put the `npm:` packages into the `$DENO_DIR`.

For the `vendor/` directory, A thin Rust script is used, to utilise a library
exposed by Deno.

For the `npm:` packages, a Deno script is used.

The `npm:` packages are downloaded as `.tgz` files and have to be extracted in this step.
