# Standardized custom fetcher for language build helpers

The document specifies the structure of a standardized custom fetcher architecture
for language build helpers in Nixpkgs.

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

## Idea

The idea is to provide a few Nixpkgs lib functions, which should be used
for new custom fetchers for language build helpers. Those functions provide
an interface which encourages building the custom fetcher in a way
that circumvents the above-mentioned problems.

### Interface

**NOTE:** The chosen function/key names serve as placeholders.

Generally speaking there are 2 ways to use FODs to fetch dependencies:

1. Use one hash and one FOD, containing all dependencies
2. Use hashes from a lock file and many FODs,
   one per lock file hash.

The proposed interface supports both ways and allows to even combine them.

A call to the interface looks like this

```nix
buildHelperFetcher packages
```

where `packages` looks like this

```nix
{
    withOneHash = schema1;
    withHashPerFile = schema2;
    preFetched = schema3;
};
```

and `schema1` looks like this

```nix
{
    hash = ""; # (optional) top level hash, required for `withOneHash`
    curlOpts = ""; # (optional) global curl opts, passed to all curl calls
    curlOptsList = []; # (optional) global curl opts, passed to all curl calls
    meta = { }; # (optional) object of arbitrary shape that is passed through
    # derivation = null; # (filled in by `fetcher`), top level derivation
    packagesFiles = [
      {
        url = ""; # (required)
        # outPath = ""; # (filled in by `fetcher`), `<top level derivation path>/<file path>`
        curlOpts = ""; # (optional) global curl opts, passed to all curl calls
        curlOptsList = []; # (optional) global curl opts, passed to all curl calls
        meta = { # (optional) object of arbitrary shape that is passed through
          packageName = ""; # (example)
          fileName = ""; # (example)
        };
      }
      # ...
    ];
  };
```

and `schema2` looks like this

```nix
{
    curlOpts = ""; # (optional) global curl opts, passed to all curl calls
    curlOptsList = []; # (optional) global curl opts, passed to all curl calls
    meta = { }; # (optional) object of arbitrary shape that is passed through
    packagesFiles = [
      {
        url = ""; # (required)
        # outPath = ""; # (filled in by `fetcher`), `<file level derivation path>/<file path>`
        # derivation = null; # (filled in by `fetcher`), file level derivation
        hash = ""; # (required)
        curlOpts = ""; # (optional) global curl opts, passed to all curl calls
        curlOptsList = []; # (optional) global curl opts, passed to all curl calls
        meta = { # (optional) object of arbitrary shape that is passed through
          packageName = ""; # (example)
          fileName = ""; # (example)
        };
      }
      # ...
    ];
  };
```

and `schema3` looks like this

```nix
{
    meta = { }; # (optional) object of arbitrary shape that is passed through
    packagesFiles = [
      {
        url = ""; # (required)
        outPath = ""; # (required)
        derivation = null; # (required)
        meta = { # (optional) object of arbitrary shape that is passed through
          packageName = ""; # (example)
          fileName = ""; # (example)
        };
      }
      # ...
    ];
  };
```

So for URLs in `withOneHash`, `fetcher` will construct a single FOD, use the top level hash
and make curl calls for all the URLs.

For `withHashPerFile`, `fetcher` will construct one FODs per `(url, hash)` pair and fetch that.

In both cases, each file gets the `outPath` property filled in by `fetcher`,
which points to the fetched file.

The files in `preFetched` are left alone by the fetcher. This key can be useful,
if some files have to be fetched beforehand, and you want to use those files through the
same interface.

With a utility function:

```nix
toPackagesFilesList (buildHelperFetcher packages)
```

the `.packagesFiles` lists are extracted and concatenated,
which provides a single list of objects, holding all necessary data to construct
the folder structure that the language-specific package manager expects.

### Usage

There are generally 3 steps to construct a custom fetcher with this interface:

1. Parse a lock file or other files listing dependencies and transform the data
   into the data structure outlined above.
2. Pass the data structure to the `fetcher` function.
3. Make a new derivation to map the list of fetched files to the folder structure that the
   language-specific package manager expects, by using the `outPath` nix store paths
   and other (meta) data associated with the file.
