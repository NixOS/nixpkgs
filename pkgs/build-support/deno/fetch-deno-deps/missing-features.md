# fetch-deno-deps missing features

Goals:
- collect knowledge about missing features in `fetch-deno-deps`

Audience:
- `fetch-deno-deps` maintainers

Required knowledge:
- `readme.md`

This file complements the `readme.md` file.

It contains both, known **problems** and **implementation suggestions**.

## Deno's dependency cache formats

### HTTPS Packages

#### Private HTTPS repositories

**Feasibility**: high

**Implementation suggestion**:
This would require us to somehow pass down the
`(credential, domain)` pairs from the nix build to the fetcher script
and then provide all `fetch` calls to the respective
domain with the respective auth headers.

### NPM Packages

#### `node_modules/` lifecycle scripts

**Feasibility**: medium

**Implementation suggestion**:
This would require us constructing the `node_modules`
directory, possibly with a rust library used by Deno:

- <https://docs.rs/deno_npm_cache/0.28.0/deno_npm_cache/>
- <https://docs.rs/deno_npm/0.35.0/deno_npm/>

And then creating a FOD and executing the lifecycle script in there, which will
require a hash in Nix.

#### Custom NPM registries and `.npmrc`

**Feasibility**: high

**Implementation suggestion**:
This would require us parsing the `.npmrc` file. Then we
need to extract the `(@scope, domain)` pairs. Also, we need to adapt the
construction of NPM URLs for the relevant scopes. And then provide all fetch
calls to the respective domain with the respective auth headers.

### Type files

**Feasibility**: low

#### Inline type imports

**Problems**:
To find the imports, we would need to parse, or at least grep all the source
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

**Problems**:
In this case, we don't need to parse the entire source code, but just the
`deno.json`, which is much easier. However all the other problems mentioned
above remain.

#### Response headers

**Problems**:
This method is slightly different from the methods above, since the required
type files will only become known in the fetch step.

The other problems mentioned above remain.

## "import from lock file" feature

**Feasibility**: low

**Problems**:
There are several technical problems, that make it currently impractical to
build the dependencies without a hash provided in Nix:

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

