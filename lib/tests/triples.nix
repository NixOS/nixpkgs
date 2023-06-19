# Run:
# [nixpkgs]$ nix-build -o expected-output lib/tests/triples.nix -A expected-output-from-gnu-config
# [nixpkgs]$ nix-instantiate --eval --strict -E '(import lib/tests/triples.nix).tests ./expected-output'
# Expected output: [], or the failed cases
# Two steps are required to avoid IFD.
#
# This file tests our triple-parser, but it needs access to `pkgs`
# because `pkgs.gnu-config` is our source of truth for the
# correctness of parsing.  This file does not test `pkgs`; it tests
# `lib`.
#
# The tests below attempt to verify that parsing followed by
# unparsing behaves the same way as `gnu-config`, except in the
# rare and unusual cases where nixpkgs has carefully and
# deliberately decided to diverge from it.
#
# We use `gnu-config` as our source of ground truth not because it
# is elegant (it isn't) or sensible (it isn't), but because it:
#
# 1. has an executable (i.e. unambiguous) specification
# 2. covers a superset of the systems on which nixpkgs could be useful
# 3. is *not* under nixpkgs' control (bickering/drama avoidance)
# 4. emanates from an organization (GNU) which understands that
#    the taxonomy is not merely an implementation detail of one of
#    their software products, and has demonstrated this
#    understanding over an extended period of time (multiple
#    decades).
#

let
  lib  = import ../default.nix;
  pkgs = import ../.. {};

  inherit (lib.systems.parse) canonicalize;

  filtered-triples = lib.pipe null [

    # start with the lists of known possibilities for each field
    (_: with lib.systems.parse; {
      cpu    = cpuTypes;
      vendor = vendors;
      kernel = kernels;
      abi    = abis;
    })

    # drop the structure; keep only the `name` attribute for each possibility
    (builtins.mapAttrs (_: lib.mapAttrsToList (k: v: v.name or k)))

    # generate every possible {cpu,vendor,kernel,abi} combination
    lib.cartesianProductOfSets

    # Then form a string triple for each of them
    (map lib.systems.parse.tripleFromSkeleton)

    # Filter out any triples for which nixpkgs throws while
    # attempting to parse.  This makes the tests much faster since
    # gnu-config needs to fork() a shell for each test case.  This is
    # safe since it is okay for nixpkgs' set of acceptable triples to
    # be a subset of gnu-config's set of acceptable triples.
    (lib.filter (triple:
      (builtins.tryEval (canonicalize triple))
        .success))

    #
    # The following are triples which we have deliberately
    # chosen to accept differently than gnu-config.  Entries here
    # impose an ongoing burden on nixpkgs, so PRs which add new
    # triples here should allow for a longer review period and
    # should be advertised widely.
    #
    (lib.filter (v:

      # gnu-config infers the vendor "pc" for these Nix doubles, but
      # nixpkgs has used ${cpu}-unknown-linux-gnu for a very long time.
      v != "x86_64-linux" && v != "i686-linux" &&
      v != "x86_64-linux-gnu" && v != "i686-linux-gnu" &&
      v != "x86_64-darwin" && v != "aarch64-darwin" &&

      # We have been shipping Broadcom VC4 forks of gcc/binutils
      # using nonstandard triples since 4aa1ffae041bb9c65eb3067e9dbaaa70710ed100
      (canonicalize v) != "vc4-elf"

      # This triple is special to GHC/Cabal/GHCJS and not recognized by autotools
      # See: https://gitlab.haskell.org/ghc/ghc/-/commit/6636b670233522f01d002c9b97827d00289dbf5c
      # https://github.com/ghcjs/ghcjs/issues/53
      && (canonicalize v) != "javascript-unknown-ghcjs"
    ))
  ];
in {
  # This derivation invokes `gnu-config` on `$NIX_BUILD_CORES`-many
  # cores to generate the expected test results.  The entire result
  # set is saved as a single outpath, and is only rebuilt when the
  # set of valid {cpus, vendors, kernels, abis} changes, which
  # happens very infrequently.
  #
  expected-output-from-gnu-config =
    pkgs.runCommandLocal "testTripleFromString" { } (

      # We create a `Makefile` with a target for each test as a
      # cheap way of using multiple cores
      ''
        echo '%:; ${pkgs.gnu-config}/config.sub $* &> results/$* || true' > Makefile
      ''

      # Now we run `make` on a gigantic list of targets (one for
      # each triple we want to test)
      + ''
        mkdir results
        make -j$NIX_BUILD_CORES --no-builtin-rules --keep-going ${lib.concatStringsSep " " filtered-triples}
      ''

      # And then dump all the results as a single JSON file.  This
      # ensures that even for jillions of test cases, only a single
      # derivation and outpath will be left on OfBorg and Hydra.
      + ''
        cd results
        (echo '{'
         for triple in *; do
           echo '"'$triple'":'
           echo -n '"'
           cat $triple
           echo '",'
         done
         echo '"":""}') | tr -d "\n" > $out
      '');

  # colordiff -u <(nix eval --json -f lib/tests/triples.nix results-from-nixpkgs | jq)
  results-from-nixpkgs =
    lib.pipe filtered-triples [
      (map
        (triple: lib.nameValuePair
          triple
          (canonicalize triple)))
      lib.listToAttrs
    ];

  # Construct a test case for each element of `filtered-triples`.
  # The `expected-output` is taken as a parameter rather than from
  # the sibling attribute above in order to avoid IFD (see
  # `lib/tests/release.nix`).
  tests = expected-output:
    let expected-parsed = builtins.fromJSON (builtins.readFile expected-output);
    in lib.runTests
      (lib.pipe filtered-triples [
        (map
          (triple:
            let
              testName = "testTripleFromString_${triple}";
            in lib.nameValuePair testName {
              expected = expected-parsed.${triple};
              expr = canonicalize triple;
            })
        )
        builtins.listToAttrs
      ]);
}

