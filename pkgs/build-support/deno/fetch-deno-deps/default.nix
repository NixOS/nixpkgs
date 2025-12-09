{
  callPackage,
  stdenvNoCC,
  lib,
  cacert,
}:
let
  inherit (callPackage ./scripts/deno/default.nix { }) fetch-deno-deps-scripts;
  inherit (callPackage ./scripts/rust/file-structure-transformer-vendor/default.nix { })
    file-structure-transformer-vendor
    ;

  transformDenoLock =
    {
      denoLock,
    }:
    lib.extendMkDerivation {
      constructDrv = stdenvNoCC.mkDerivation;
      extendDrvArgs =
        _: args:
        let
          pname = args.pname or "";
          version = args.version or "";
        in
        {
          name = "denoDeps-transformedDenoLock-${pname}-${version}";
          src = null;
          unpackPhase = "true";
          buildPhase = ''
            mkdir -p $out
            lockfile-transformer \
              --deno-lock-path ${denoLock} \
              --common-lock-jsr-path $out/jsr.json \
              --common-lock-npm-path $out/npm.json \
              --common-lock-https-path $out/https.json;
          '';
          nativeBuildInputs = [
            fetch-deno-deps-scripts
          ];

          meta = {
            maintainers = [ lib.maintainers.aMOPel ];
          };
        }
        // args;
    };

  singleFodFetcher =
    {
      transformedDenoLock,
      denoLock,
      hash,
      fodNameGenerator,
      enableAutoFodInvalidation,
      argNamesForFodInvalidation,
      ...
    }:
    lib.extendMkDerivation {
      constructDrv = stdenvNoCC.mkDerivation;
      extendDrvArgs =
        _: args:
        let
          defaultArgs = {
            src = null;
            unpackPhase = "true";
            buildPhase = ''
              echo hi
              single-fod-fetcher \
                --common-lock-jsr-path ${transformedDenoLock}/jsr.json \
                --common-lock-npm-path ${transformedDenoLock}/npm.json \
                --common-lock-https-path ${transformedDenoLock}/https.json \
                --out-path-prefix $out;
              cp ${denoLock} $out/deno.lock
            '';
            nativeBuildInputs = [
              fetch-deno-deps-scripts
            ];
            SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

            outputHashMode = "recursive";
            outputHash = hash;
            outputHashAlgo = "sha256";

            meta = {
              maintainers = [ lib.maintainers.aMOPel ];
            };
          };

          argsForFodInvalidation = lib.filterAttrs (
            name: _: builtins.any (otherName: name == otherName) argNamesForFodInvalidation
          ) mergedArgs;

          mergedArgs = defaultArgs // args;

          pname = args.pname or "";
          version = args.version or "";
          name = args.name or "denoDeps-fetched-${pname}-${version}";
        in
        (
          mergedArgs
          // {
            name =
              if enableAutoFodInvalidation then fodNameGenerator argsForFodInvalidation pname version else name;
          }
        );
    };

  # this derivation only meant to be used, if the dependency dir is needed outside of buildDenoPackage
  # when using buildDenoPackage, the steps of this derivation are performed inside buildDenoPackage,
  # to avoid an unnecessary derivation in the cache
  transformFiles =
    {
      fetched,
      denoDir,
      vendorDir,
      ...
    }:
    lib.extendMkDerivation {
      constructDrv = stdenvNoCC.mkDerivation;
      extendDrvArgs =
        _: args:
        let
          pname = args.pname or "";
          version = args.version or "";
        in
        {
          name = "denoDeps-final-${pname}-${version}";
          src = null;
          unpackPhase = "true";
          nativeBuildInputs = [
            fetch-deno-deps-scripts
            file-structure-transformer-vendor
          ];
          buildPhase = ''
            export vendorDir="$out/${vendorDir}";
            export DENO_DIR="$out/${denoDir}";
            mkdir -p $DENO_DIR;
            mkdir -p $vendorDir;
            file-structure-transformer-npm \
              --deno-dir-path $DENO_DIR \
              --common-lock-npm-path "${fetched}/npm.json";
            file-structure-transformer-vendor \
              --deno-dir-path $DENO_DIR \
              --vendor-dir-path $vendorDir \
              --common-lock-jsr-path "${fetched}/jsr.json" \
              --common-lock-https-path "${fetched}/https.json";
          '';

          meta = {
            maintainers = [ lib.maintainers.aMOPel ];
          };
        }
        // args;
    };

in
{
  fetchDenoDeps =
    {
      denoLock,
      hash ? lib.fakeHash,
      denoDir ? ".deno",
      vendorDir ? "vendor",

      # whether to enable automatic invalidation of the fetcher fod (fixed output derivation)
      # use together with `fodNameGenerator` and `argNamesForFodInvalidation`
      # by default all derivation args in `argNamesForFodInvalidation` are used to create a hash,
      # which becomes part of the name of the fetcher fod, if any of those args change, the fod gets a new name and is invalidated
      #
      # we do this to make sure that we become aware of bugs in the fetcher immediately,
      # e.g. after breaking changes in deno upstream force source changes to the fetcher,
      # and not after years, when the fods slowly get removed from the nix cache
      enableAutoFodInvalidation ? true,
      # function to generate the name of fetcher fod, see `enableAutoFodInvalidation`
      fodNameGenerator ?
        argsForFodInvalidation: pname: version:
        "${builtins.hashString "sha1" (builtins.toJSON  argsForFodInvalidation)}-${pname}-${version}",
      # invalidate fod, if any of these derivation args change, see `enableAutoFodInvalidation`
      argNamesForFodInvalidation ? [
        "src"
        "unpackPhase"
        "buildPhase"
        "nativeBuildInputs"
      ],
      # derivation args passed to step 1, the deno lock file transformer step
      transformDenoLockArgs ? { },
      # derivation args passed to step 2, the fetcher step
      fetcherArgs ? { },
      # derivation args passed to step 3, the file structure transformer
      transformFileStructureArgs ? { },
      # derivation args passed to all 3 steps
      globalArgs ? { },
    }:
    let

      transformedDenoLock = transformDenoLock {
        inherit denoLock;
      } (globalArgs // transformDenoLockArgs);

      fetched = singleFodFetcher {
        inherit
          denoLock
          transformedDenoLock
          hash
          fodNameGenerator
          enableAutoFodInvalidation
          argNamesForFodInvalidation
          ;
      } (globalArgs // fetcherArgs);

      denoDeps = transformFiles {
        inherit
          fetched
          denoDir
          vendorDir
          ;
      } (globalArgs // transformFileStructureArgs);
    in
    {
      inherit
        transformedDenoLock
        fetched
        denoDeps
        ;
    };
}
