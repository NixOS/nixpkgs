{
  lib,
  stdenvNoCC,
  rustPlatform,
  makeWrapper,
  pkg-config,
  curl,
  gnutar,
  gzip,
  testers,
  fetchurl,
  cacert,
  prefetch-npm-deps,
  fetchNpmDeps,
}:

{
  prefetch-npm-deps = rustPlatform.buildRustPackage {
    pname = "prefetch-npm-deps";
    version = (lib.importTOML ./Cargo.toml).package.version;

    src = lib.cleanSourceWith {
      src = ./.;
      filter =
        name: type:
        let
          name' = builtins.baseNameOf name;
        in
        name' != "default.nix" && name' != "target";
    };

    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];
    buildInputs = [ curl ];

    postInstall = ''
      wrapProgram "$out/bin/prefetch-npm-deps" --prefix PATH : ${
        lib.makeBinPath [
          gnutar
          gzip
        ]
      }
    '';

    passthru.tests =
      let
        makeTestSrc =
          { name, src }:
          stdenvNoCC.mkDerivation {
            name = "${name}-src";

            inherit src;

            buildCommand = ''
              mkdir -p $out
              cp $src $out/package-lock.json
            '';
          };

        makeTest =
          {
            name,
            src,
            hash,
            forceGitDeps ? false,
            forceEmptyCache ? false,
          }:
          testers.invalidateFetcherByDrvHash fetchNpmDeps {
            inherit
              name
              hash
              forceGitDeps
              forceEmptyCache
              ;

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

        # This package has no resolved deps whatsoever, which will not actually work but does test the forceEmptyCache option.
        emptyCache = makeTest {
          name = "empty-cache";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/bufbuild/protobuf-es/v1.2.1/package-lock.json";
            hash = "sha256-UdBUEb4YRHsbvyjymIyjemJEiaI9KQRirqt+SFSK0wA=";
          };

          hash = "sha256-Cdv40lQjRszzJtJydZt25uYfcJVeJGwH54A+agdH9wI=";

          forceEmptyCache = true;
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

        # This package has a lockfile v1 git dependency with no `dependencies` attribute, since it sementically has no dependencies.
        jitsiMeet9111 = makeTest {
          name = "jitsi-meet-9111";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/jitsi/jitsi-meet/stable/jitsi-meet_9111/package-lock.json";
            hash = "sha256-NU+eQD4WZ4BMur8uX79uk8wUPsZvIT02KhPWHTmaihk=";
          };

          hash = "sha256-FhxlJ0HdJMPiWe7+n1HaGLWOr/2HJEPwiS65uqXZM8Y=";
        };
      };

    meta = with lib; {
      description = "Prefetch dependencies from npm (for use with `fetchNpmDeps`)";
      mainProgram = "prefetch-npm-deps";
      maintainers = with maintainers; [ winter ];
      license = licenses.mit;
    };
  };

  fetchNpmDeps =
    {
      name ? "npm-deps",
      hash ? "",
      forceGitDeps ? false,
      forceEmptyCache ? false,
      ...
    }@args:
    let
      hash_ =
        if hash != "" then
          {
            outputHash = hash;
          }
        else
          {
            outputHash = "";
            outputHashAlgo = "sha256";
          };

      forceGitDeps_ = lib.optionalAttrs forceGitDeps { FORCE_GIT_DEPS = true; };
      forceEmptyCache_ = lib.optionalAttrs forceEmptyCache { FORCE_EMPTY_CACHE = true; };
    in
    stdenvNoCC.mkDerivation (
      args
      // {
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

        # NIX_NPM_TOKENS environment variable should be a JSON mapping in the shape of:
        # `{ "registry.example.com": "example-registry-bearer-token", ... }`
        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [ "NIX_NPM_TOKENS" ];

        SSL_CERT_FILE =
          if
            (
              hash_.outputHash == ""
              || hash_.outputHash == lib.fakeSha256
              || hash_.outputHash == lib.fakeSha512
              || hash_.outputHash == lib.fakeHash
            )
          then
            "${cacert}/etc/ssl/certs/ca-bundle.crt"
          else
            "/no-cert-file.crt";

        outputHashMode = "recursive";
      }
      // hash_
      // forceGitDeps_
      // forceEmptyCache_
    );
}
