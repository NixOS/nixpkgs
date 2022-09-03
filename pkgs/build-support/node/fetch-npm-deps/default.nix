{ lib, stdenvNoCC, rustPlatform, Security, testers, fetchurl, prefetch-npm-deps, fetchNpmDeps }:

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

    buildInputs = lib.optional stdenvNoCC.isDarwin Security;

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

        makeTest = { name, src, hash }: testers.invalidateFetcherByDrvHash fetchNpmDeps {
          inherit name hash;

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

          hash = "sha256-fk7L9vn8EHJsGJNMAjYZg9h0PT6dAwiahdiEeXVrMB8=";
        };

        lockfileV2 = makeTest {
          name = "lockfile-v2";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/jesec/flood/v4.7.0/package-lock.json";
            hash = "sha256-qS29tq5QPnGxV+PU40VgMAtdwVLtLyyhG2z9GMeYtC4=";
          };

          hash = "sha256-s8SpZY/1tKZVd3vt7sA9vsqHvEaNORQBMrSyhWpj048=";
        };

        hashPrecedence = makeTest {
          name = "hash-precedence";

          src = fetchurl {
            url = "https://raw.githubusercontent.com/matrix-org/matrix-appservice-irc/0.34.0/package-lock.json";
            hash = "sha256-1+0AQw9EmbHiMPA/H8OP8XenhrkhLRYBRhmd1cNPFjk=";
          };

          hash = "sha256-KRxwrEij3bpZ5hbQhX67KYpnY2cRS7u2EVZIWO1FBPM=";
        };

        hostedGitDeps = makeTest {
          name = "hosted-git-deps";

          src = fetchurl {
            url = "https://cyberchaos.dev/yuka/trainsearch/-/raw/e3cba6427e8ecfd843d0f697251ddaf5e53c2327/package-lock.json";
            hash = "sha256-X9mCwPqV5yP0S2GonNvpYnLSLJMd/SUIked+hMRxDpA=";
          };

          hash = "sha256-oIM05TGHstX1D4k2K4TJ+SHB7H/tNKzxzssqf0GJwvY=";
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
    in
    stdenvNoCC.mkDerivation (args // {
      inherit name;

      nativeBuildInputs = [ prefetch-npm-deps ];

      buildPhase = ''
        runHook preBuild

        if [[ ! -f package-lock.json ]]; then
          echo
          echo "ERROR: The package-lock.json file does not exist!"
          echo
          echo "package-lock.json is required to make sure that npmDepsHash doesn't change"
          echo "when packages are updated on npm."
          echo
          echo "Hint: You can use the patches attribute to add a package-lock.json manually to the build."
          echo

          exit 1
        fi

        prefetch-npm-deps package-lock.json $out

        runHook postBuild
      '';

      dontInstall = true;

      outputHashMode = "recursive";
    } // hash_);
}
