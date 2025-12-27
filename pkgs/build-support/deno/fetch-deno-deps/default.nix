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

  transformDenoLock = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    # don't let these bleed into the derivation environment
    excludeDrvArgNames = [
      "denoLock"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        denoLock,
        pname,
        version,
        ...
      }@args:
      {
        strictDeps = true;
        __structuredAttrs = true;
        name = args.name or "denoDeps-transformedDenoLock-${finalAttrs.pname}-${finalAttrs.version}";
        src = denoLock;
        unpackCmd = ''
          mkdir -p ./source;
          cat $curSrc > ./source/deno.lock;
        '';
        buildPhase = ''
          runHook preBuild

          mkdir -p $out
          lockfile-transformer \
            --deno-lock-path ./deno.lock \
            --common-lock-jsr-path $out/jsr.json \
            --common-lock-npm-path $out/npm.json \
            --common-lock-https-path $out/https.json;

          runHook postBuild
        '';
        nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
          fetch-deno-deps-scripts
        ];

        meta = (args.meta or { }) // {
          maintainers = [ lib.maintainers.aMOPel ];
        };
      };
  };

  singleFodFetcher = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    # don't let these bleed into the derivation environment
    excludeDrvArgNames = [
      "transformedDenoLock"
      "denoLock"
      "hash"
      "fodNameGenerator"
      "enableAutoFodInvalidation"
      "argNamesForFodInvalidation"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        transformedDenoLock,
        denoLock,
        hash,
        fodNameGenerator,
        enableAutoFodInvalidation,
        argNamesForFodInvalidation,
        pname,
        version,
        ...
      }@args:
      let
        argsForFodInvalidation = lib.filterAttrs (
          name: _: builtins.any (otherName: name == otherName) argNamesForFodInvalidation
        ) finalAttrs;
        defaultName = "denoDeps-fetched-${finalAttrs.pname}-${finalAttrs.version}";
      in
      {
        strictDeps = true;
        __structuredAttrs = true;
        name =
          if enableAutoFodInvalidation then
            fodNameGenerator argsForFodInvalidation finalAttrs.pname finalAttrs.version
          else
            args.name or defaultName;
        src = transformedDenoLock;
        buildPhase = ''
          runHook preBuild

          single-fod-fetcher \
            --common-lock-jsr-path ./jsr.json \
            --common-lock-npm-path ./npm.json \
            --common-lock-https-path ./https.json \
            --out-path-prefix $out;
          cp ${denoLock} $out/deno.lock

          runHook postBuild
        '';
        nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
          fetch-deno-deps-scripts
        ];
        SSL_CERT_FILE = args.SSL_CERT_FILE or "${cacert}/etc/ssl/certs/ca-bundle.crt";

        outputHashMode = "recursive";
        outputHash = hash;
        outputHashAlgo = "";

        meta = (args.meta or { }) // {
          maintainers = [ lib.maintainers.aMOPel ];
        };
      };
  };

  # this derivation only meant to be used, if the dependency dir is needed outside of buildDenoPackage
  # when using buildDenoPackage, the steps of this derivation are performed inside buildDenoPackage,
  # to avoid an unnecessary derivation in the cache
  transformFiles = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    # don't let these bleed into the derivation environment
    excludeDrvArgNames = [
      "fetched"
      "denoDir"
      "vendorDir"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        fetched,
        denoDir,
        vendorDir,
        pname,
        version,
        ...
      }@args:
      {
        strictDeps = true;
        __structuredAttrs = true;
        name = args.name or "denoDeps-final-${finalAttrs.pname}-${finalAttrs.version}";
        src = fetched;
        nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
          fetch-deno-deps-scripts
          file-structure-transformer-vendor
        ];
        buildPhase = ''
          runHook preBuild;

          export vendorDir="$out/${vendorDir}";
          export DENO_DIR="$out/${denoDir}";
          mkdir -p $DENO_DIR;
          mkdir -p $vendorDir;
          file-structure-transformer-npm \
            --deno-dir-path $DENO_DIR \
            --common-lock-npm-path "./npm.json";
          file-structure-transformer-vendor \
            --deno-dir-path $DENO_DIR \
            --vendor-dir-path $vendorDir \
            --common-lock-jsr-path "./jsr.json" \
            --common-lock-https-path "./https.json";

          runHook postBuild;
        '';
        meta = (args.meta or { }) // {
          maintainers = [ lib.maintainers.aMOPel ];
        };
      };
  };

in
{
  fetchDenoDeps =
    {
      denoLock,
      hash ? lib.fakeHash,
      denoDir ? ".deno",
      vendorDir ? "vendor",
      pname ? "",
      version ? "",

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
        "${builtins.hashString "sha1" (builtins.toJSON argsForFodInvalidation)}-${pname}-${version}",
      # invalidate fod, if any of these derivation args change, see `enableAutoFodInvalidation`
      argNamesForFodInvalidation ? [
        "src"
        "dontUnpack"
        "buildPhase"
        "nativeBuildInputs"
      ],
      # derivation args passed to step 1, the deno lock file transformer step
      transformDenoLockArgs ? { },
      # derivation args passed to step 2, the fetcher step
      fetcherArgs ? { },
      # derivation args passed to step 3, the file structure transformer step
      transformFileStructureArgs ? { },
      # derivation args passed to all 3 steps
      globalArgs ? { },
    }:
    let

      transformedDenoLock = transformDenoLock (
        {
          inherit denoLock pname version;
        }
        // globalArgs
        // transformDenoLockArgs
      );

      fetched = singleFodFetcher (
        {
          inherit
            denoLock
            transformedDenoLock
            hash
            fodNameGenerator
            enableAutoFodInvalidation
            argNamesForFodInvalidation
            pname
            version
            ;
        }
        // globalArgs
        // fetcherArgs
      );

      denoDeps = transformFiles (
        {
          inherit
            fetched
            denoDir
            vendorDir
            pname
            version
            ;
        }
        // globalArgs
        // transformFileStructureArgs
      );
    in
    {
      inherit
        transformedDenoLock
        fetched
        denoDeps
        ;
    };
}
