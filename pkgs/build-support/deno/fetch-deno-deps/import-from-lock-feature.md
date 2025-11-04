# fetch-deno-deps "import from lock file" feature **Not implemented**

Goals:

- collect knowledge about the "import from lock file" feature in
  `fetch-deno-deps`

Audience:

- `fetch-deno-deps` maintainers

Required knowledge:

- `readme.md`
- how nix package maintainers operate on packages, roughly
- how developers package their own projects with nix, roughly

This file complements the `readme.md` file.

## What is "import from lock file"?

By default, to fetch anything from the internet in Nixpkgs, you need a fixed
output derivation, which requires an `outputHash` to verify, that the output did
not change compared to last time.

For a build helper this means, when we want to download the dependencies of a
package, we need to provide at least one hash.

This is a nuisance, since we need to manually change the hash each time the
dependencies change. For a package maintained in Nixpkgs it does not occur that
often, however if the build-helper is used when developing a package, it does.

Since there are usually integrity hashes for packages in lock files, we could
theoretically just use those, and circumvent having to specify a hash in Nix.

To do that, we need to parse the lock file in Nix. **Mind that this step implies
IFD**, if the lock-file is not part of the same repo, but is for example fetched
from a remote repo with `fetchGit`.

With the parsed lock-file, we then create separate FODs one per `(url, hash)`
pair. Also, we need to collect all those FODs and associate them with enough
meta information to enable us to transform them into a file structure, that the
language's package manager will understand.

All the logic to parse the lock-file and fetch the files, **has to be written in
Nix**.

Creating many FODs can have serious performance implications, since each FOD
means a new build container and build environment etc. So the disk IO can become
a bottleneck if this goes into the thousands.

See also:
- [docs on import from lock feature for `buildNpmPackage`](https://nixos.org/manual/nixpkgs/stable/#javascript-buildNpmPackage-importNpmLock)
- [source code for `import-npm-lock`](https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support/node/import-npm-lock)

## "Packaging in nixpkgs" vs "packaging while developing"

There are two different user scenarios to consider:

1. Package maintainers in Nixpkgs, that want to package some remote source code
   using the build-helper.

   Since they can't use IFD, they can't just fetch the source code in a build
   and then import that lock file in Nix.

   This usually means, they provide the hash manually.

   Sometimes the remote source code does not have a lock-file. Then they have to
   generate and vendor the lock file in the Nixpkgs repo.

2. Developers, writing their own language package, that want to package their
   local code with Nix using the build-helper.

   Developers usually don't care about IFD, but they do care about the nuisance
   of having to manually change the hash every time they import a new package
   while developing.

## Summary

So to summarize:

To provide the package maintainers with the functionality they require, we have
to write the entire logic to parse the lock file and fetch the files, in a way
that it can be executed inside a derivation, because of the IFD constraint. So
it can't be written using the Nix language.

And to provide the developers with the functionality they would like, we have to
write the logic in the Nix language.

So we end up with two implementations, doing basically the same thing but
slightly different.

## Problems

There are several technical problems, that make it currently impractical to
build the dependencies without a hash provided in Nix:

1. **Nixpkgs requirements**: The necessity in Nixpkgs to split the "fetch FOD"
   from the "file transformation step", makes it impossible, since we need to
   record the response headers in a separate FOD and then transform the files in
   the another derivation using that information. Since there is no information
   in the lock file about the headers, we have to copy the headers information
   to `$out` of the FOD, which changes the hash, so we can't use the hashes from
   the lock file for all the fetches where we need to record the headers.
1. **Performance**: JSR's API architecture requires us to create a FOD per file
   of a dependency (not per package, like NPM). This provides great granular
   caching, but terrible performance when fetching, since the disc IO quickly
   gets out of hand, with big JSR packages with hundreds of files. I actually
   tested this, and a fetch with many jsr dependencies could really take a few
   minutes, compared to the seconds it takes now.
1. **Nix compatability**: Type file imports (which are not supported anyway, due
   to their complexity) cannot work with this feature, since there are no hashes
   for them in the lock-file, and some type files may only become known in the
   fetch step.
1. **Feasibility**: This feature would require a complete reimplementation of
   all the fetching logic in Nix, which is a lot of effort, due to its
   complexity. And the maintenance effort would double, which is not desirable,
   since Deno's dependency cache API is still unstable.
