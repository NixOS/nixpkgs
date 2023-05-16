{ stdenv, lib, makeWrapper, coreutils, nix-prefetch-git, fetchurl, nodejs-slim, prefetch-yarn-deps, cacert, callPackage, nix }:

let
  yarnpkg-lockfile-tar = fetchurl {
    url = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz";
    sha512 = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==";
  };

<<<<<<< HEAD
  tests = callPackage ./tests {};

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in {
  prefetch-yarn-deps = stdenv.mkDerivation {
    name = "prefetch-yarn-deps";

    dontUnpack = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ coreutils nix-prefetch-git nodejs-slim nix ];

    buildPhase = ''
      runHook preBuild

      mkdir libexec
      tar --strip-components=1 -xf ${yarnpkg-lockfile-tar} package/index.js
      mv index.js libexec/yarnpkg-lockfile.js
<<<<<<< HEAD
      cp ${./.}/*.js libexec/
      patchShebangs libexec
=======
      cp ${./index.js} libexec/index.js
      patchShebangs libexec/index.js
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r libexec $out
      makeWrapper $out/libexec/index.js $out/bin/prefetch-yarn-deps \
        --prefix PATH : ${lib.makeBinPath [ coreutils nix-prefetch-git nix ]}
<<<<<<< HEAD
      makeWrapper $out/libexec/fixup.js $out/bin/fixup-yarn-lock

      runHook postInstall
    '';

    passthru = { inherit tests; };
=======

      runHook postInstall
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  fetchYarnDeps = let
    f = {
      name ? "offline",
      src ? null,
      hash ? "",
      sha256 ? "",
      ...
    }@args: let
      hash_ =
        if hash != "" then { outputHashAlgo = null; outputHash = hash; }
        else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
        else { outputHashAlgo = "sha256"; outputHash = lib.fakeSha256; };
    in stdenv.mkDerivation ({
      inherit name;

      dontUnpack = src == null;
      dontInstall = true;

      nativeBuildInputs = [ prefetch-yarn-deps ];
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      buildPhase = ''
        runHook preBuild

        yarnLock=''${yarnLock:=$PWD/yarn.lock}
        mkdir -p $out
        (cd $out; prefetch-yarn-deps --verbose --builder $yarnLock)

        runHook postBuild
      '';

      outputHashMode = "recursive";
    } // hash_ // (removeAttrs args ["src" "name" "hash" "sha256"]));

  in lib.setFunctionArgs f (lib.functionArgs f) // {
<<<<<<< HEAD
    inherit tests;
=======
    tests = callPackage ./tests {};
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
