# Proposal for better documentation of custom fetcher architecture for language build helpers

What are

## Current problems

### FOD caching causes rebuild delay

Generally speaking, Nixpkgs wants language build helpers to use custom fetchers,
instead of just invoking the language-specific package manager CLI to fetch the packages.

The reason is that the package manager CLI version will change,
as it is updated in Nixpkgs and with such a change,
the FOD that was produced by the build helper can change.

This can become a huge problem for Nixpkgs, since FODs use hashes over the output
to find cached results in the Nix store. The hash of a FOD won't change until done manually,
which means as long as that step is not performed, the cached, outdated version from the Nix store will
be used. A rebuild of the FOD however would now produce a new version with a different hash.
Because the nix cache will hold those FODs potentially for years, there can be a huge
delay until a breaking change in the package manager CLI is recognized, which will make
debugging very difficult.

This has caused problems in the past, and is now to be avoided.

### Breaking FODs as few times as possible

Since FODs generally require manually inserting a hash, it can be a cumbersome
process if done many times.

So custom fetchers should try to require changing hashes of FODs as few times as possible.

To do this, we need to decouple the fetching step from all the other language-specific
logic, so that a change to any format the package manager uses, does not require
a change to the hash of the FOD.

### Import from derivation (IFD) and "import from lock file" feature

**What is IFD:**

<https://nix.dev/manual/nix/2.23/language/import-from-derivation>

IFD forbids us to read a file from a derivation in Nix code.

IFD is forbidden in nixpkgs due to performance implications.
This means a build helper has to provide an IFD-free build.

So the entire logic to parse the lock file and fetch all dependencies,
has to be run inside one or multiple derivations and can never "go back up" into
the Nix realm.

The derivation containing the fetched files, then is an input to the derivation
building the package.

---

**What is "import from lock file":**
By default to fetch anything from the internet in nixpkgs, you need a fixed output derivation, which
requires an outputHash to verify, that the output did not change compared to last time.

For a build helper this means, when we want to download the depedencies of a
package, we need to provide at least one hash.

This is a nuisance, since we need to manually change the hash each time the dependencies change.
For a package maintained in nixpkgs it does not occur that often, however if the build-helper is used
when developing a package, it does.

Since there are usually integrity hashes for packages in lock files,
we could theoretically just use those, and circumvent having to specify a hash
in Nix.

To do that, we need to parse the lock file in Nix and then create separate FODs
one per `(url, hash)` and then we still need to collect all those FODs and
associate them with enough meta information to enable us to transform them
into a file structure, that the language's package manager will understand.

Creating many FODs can have serious performance implications, since each FOD
is means a new build container and build environment etc. So the disk IO can
escalate if this goes into the thousands.

---

**packaging in nixpkgs vs packaging while developing:**

There are two different user scenarios to consider:

1. Package maintainers in nixpkgs, that want to package some remote source code
in a nix build using the build-helper.

Since they can't use IFD, they can't just fetch the source code in a build and then import that lock file in Nix.

This usually means, they either provide the hash manually.
But sometimes they vendor (hard copy) the lock file in the nixpkgs repo and would like
to not avoid specifying the hash manually.

Sometimes they have to vendor the lock file, since the remote source code, does
not have lock file and they have to generate it first.

2. Developers, writing their own language package, that want to package their
local code into a nix build using the build-helper.

Developers usually don't care about IFD, but they do care about the nuisance
of having to manually change the hash every time they import a new package
while developing.

---

**Problem:**

So to summarize:

To provide the package maintainers with the functionality they require,
we have to write the entire logic to parse the lock file and fetch the files,
in a way that it can be executed inside a derivation, because of the IFD constraint.

And to provide the developers with the functionality the would like,
we have to write the logic purely in Nix.

So we end up with two implementations, doing basically the same thing
but slightly different.

## Approach

![architecture diagram](./builder-architecture.drawio.svg)

As a horizontal line, we see a divide between eval time and build time.

It's important to differentiate here, because everything in eval time,
is written in Nix and everything in build time is executed in a build container,
using some language different from Nix.

Also, whenever we have data flow from build time to eval time, we do an IFD.

The separation of the 3 concerns
1. lock file transformation
2. fetching
3. directory structure transformation

Stems from the first two problems above:
- "FOD caching causes rebuild delay"
- "Breaking FODs as few times as possible"
Since we want to break FODs as few times as possible, we need to separate the
fetching step from
the lock file parsing step and the directory structure transformation step.

The directory structure transformation step happens during the package build
to avoid having to cache the same files twice, once from step 2 and once from
step 3. This is important to reduce load on the nixpkgs cache servers.

As we can see, to not have IFD, and to have an "import from lock" fetcher,
we need two separate implementations of step 1 and step 2, one running at build time, one running at eval time.
