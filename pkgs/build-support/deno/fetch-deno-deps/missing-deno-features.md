# fetch-deno-deps missing deno features

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

**Implementation suggestion**: This would require us to somehow pass down the
`(credential, domain)` pairs from the nix build to the fetcher script and then
provide all `fetch` calls to the respective domain with the respective auth
headers.

### NPM Packages

#### `node_modules/` lifecycle scripts

**Feasibility**: medium

**Implementation suggestion**: This would require us constructing the
`node_modules` directory, possibly with a rust library used by Deno:

- <https://docs.rs/deno_npm_cache/0.28.0/deno_npm_cache/>
- <https://docs.rs/deno_npm/0.35.0/deno_npm/>

And then creating a FOD and executing the lifecycle script in there, which will
require a hash in Nix.

#### Custom NPM registries and `.npmrc`

**Feasibility**: high

**Implementation suggestion**: This would require us parsing the `.npmrc` file.
Then we need to extract the `(@scope, domain)` pairs. Also, we need to adapt the
construction of NPM URLs for the relevant scopes. And then provide all fetch
calls to the respective domain with the respective auth headers.

### Type files

**Feasibility**: low

#### Inline type imports

**Problems**: To find the imports, we would need to parse, or at least grep all
the source code, and possibly all the source code of dependencies and fetch the
type dependencies.

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

**Problems**: In this case, we don't need to parse the entire source code, but
just the `deno.json`, which is much easier. However all the other problems
mentioned above remain.

#### Response headers

**Problems**: This method is slightly different from the methods above, since
the required type files will only become known in the fetch step.

The other problems mentioned above remain.
