{ lib, stdenvNoCC, rustPlatform, makeWrapper, Security, gnutar, gzip, nix, testers, fetchurl, prefetch-npm-deps, fetchNpmDeps }:

{
  prefetch-npm-deps = rustPlatform.buildRustPackage {
    pname = "prefetch-npm-deps";
    version = (lib.importTOML ./Cargo.toml).package.version;

    src = lib.cleanSourceWith {
      src = ./.;
      filter = name: type:
        let
          name' = builtins.baseNameOf name;
        in
        name' != "default.nix" && name' != "target";
    };

    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = lib.optional stdenvNoCC.isDarwin Security;

    postInstall = ''
      wrapProgram "$out/bin/prefetch-npm-deps" --prefix PATH : ${lib.makeBinPath [ gnutar gzip nix ]}
    '';

    passthru.tests =
      let
        makeTestSrc = { name, src }: stdenvNoCC.mkDerivation {
          name = "${name}-src";

          inherit src;

          buildCommand = ''
            mkdir -p $out
            cp $src $out/package-lock.json
          '';
        };

        makeTest = { name, src, hash, forceGitDeps ? false }: testers.invalidateFetcherByDrvHash fetchNpmDeps {
          inherit name hash forceGitDeps;

          src = makeTestSrc { inherit name src; };
        };
      in
      {
        lockfileV1 = makeTest {
          name = "lockfile-v1";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/jellyfin/jellyfin-web/v10.8.4/package-lock.json";
            hash = "sha256-uQmc+S+V1co1Rfc4d82PpeXjmd1UqdsG492ADQFcZGA=";
          };

          hash = "sha256-wca1QvxUw3OrLStfYN9Co6oVBR1LbfcNUKlDqvObps4=";
        };

        lockfileV2 = makeTest {
          name = "lockfile-v2";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/jesec/flood/v4.7.0/package-lock.json";
            hash = "sha256-qS29tq5QPnGxV+PU40VgMAtdwVLtLyyhG2z9GMeYtC4=";
          };

          hash = "sha256-tuEfyePwlOy2/mOPdXbqJskO6IowvAP4DWg8xSZwbJw=";
        };

        hashPrecedence = makeTest {
          name = "hash-precedence";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/matrix-org/matrix-appservice-irc/0.34.0/package-lock.json";
            hash = "sha256-1+0AQw9EmbHiMPA/H8OP8XenhrkhLRYBRhmd1cNPFjk=";
          };

          hash = "sha256-oItUls7AXcCECuyA+crQO6B0kv4toIr8pBubNwB7kAM=";
        };

        hostedGitDeps = makeTest {
          name = "hosted-git-deps";

          src = fetchurl {
            url = "https://cyberchaos.dev/yuka/trainsearch/-/raw/e3cba6427e8ecfd843d0f697251ddaf5e53c2327/package-lock.json";
            hash = "sha256-X9mCwPqV5yP0S2GonNvpYnLSLJMd/SUIked+hMRxDpA=";
          };

          hash = "sha256-tEdElWJ+KBTxBobzXBpPopQSwK2usGW/it1+yfbVzBw=";
        };

        linkDependencies = makeTest {
          name = "link-dependencies";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/evcc-io/evcc/0.106.3/package-lock.json";
            hash = "sha256-6ZTBMyuyPP/63gpQugggHhKVup6OB4hZ2rmSvPJ0yEs=";
          };

          hash = "sha256-VzQhArHoznYSXUT7l9HkJV4yoSOmoP8eYTLel1QwmB4=";
        };

        # This package contains both hosted Git shorthand, and a bundled dependency that happens to override an existing one.
        etherpadLite1818 = makeTest {
          name = "etherpad-lite-1.8.18";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/ether/etherpad-lite/1.8.18/src/package-lock.json";
            hash = "sha256-1fGNxYJi1I4cXK/jinNG+Y6tPEOhP3QAqWOBEQttS9E=";
          };

          hash = "sha256-+KA8/orSBJ4EhuSyQO8IKSxsN/FAsYU3lOzq+awuxNQ=";

          forceGitDeps = true;
        };
      };

    meta = with lib; {
      description = "Prefetch dependencies from npm (for use with `fetchNpmDeps`)";
      maintainers = with maintainers; [ winter ];
      license = licenses.mit;
    };
  };

  fetchNpmDeps =
    { name ? "npm-deps"
    , hash ? ""
    , forceGitDeps ? false
    , ...
    } @ args:
    let
      hash_ =
        if hash != "" then {
          outputHash = hash;
        } else {
          outputHash = "";
          outputHashAlgo = "sha256";
        };

      forceGitDeps_ = lib.optionalAttrs forceGitDeps { FORCE_GIT_DEPS = true; };
    in
    stdenvNoCC.mkDerivation (args // {
      inherit name;

      nativeBuildInputs = [ prefetch-npm-deps ];

      buildPhase = ''
        runHook preBuild

        if [[ ! -e package-lock.json ]]; then
          echo
          echo "ERROR: The package-lock.json file does not exist!"
          echo
          echo "package-lock.json is required to make sure that npmDepsHash doesn't change"
          echo "when packages are updated on npm."
          echo
          echo "Hint: You can copy a vendored package-lock.json file via postPatch."
          echo

          exit 1
        fi

        prefetch-npm-deps package-lock.json $out

        runHook postBuild
      '';

      dontInstall = true;

      outputHashMode = "recursive";
    } // hash_ // forceGitDeps_);
}
