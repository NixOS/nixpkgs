{ stdenv, lib, makeWrapper, coreutils, nix-prefetch-git, fetchurl, nodejs-slim, prefetch-yarn-deps, cacert, callPackage, nix }:

let
  yarnpkg-lockfile-tar = fetchurl {
    url = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz";
    sha512 = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==";
  };

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
      cp ${./index.js} libexec/index.js
      patchShebangs libexec/index.js

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r libexec $out
      makeWrapper $out/libexec/index.js $out/bin/prefetch-yarn-deps \
        --prefix PATH : ${lib.makeBinPath [ coreutils nix-prefetch-git nix ]}

      runHook postInstall
    '';
  };

  fetchYarnDeps = let
    f = {
      name ? "offline",
      yarnLock,
      hash ? "",
      sha256 ? "",
    }: let
      hash_ =
        if hash != "" then { outputHashAlgo = null; outputHash = hash; }
        else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
        else throw "fetchYarnDeps requires a hash";
    in stdenv.mkDerivation {
      inherit name;

      dontUnpack = true;
      dontInstall = true;

      nativeBuildInputs = [ prefetch-yarn-deps ];
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      buildPhase = ''
        mkdir -p $out
        (cd $out; prefetch-yarn-deps --verbose --builder ${yarnLock})
      '';

      outputHashMode = "recursive";
      inherit (hash_) outputHashAlgo outputHash;
    };

  in lib.setFunctionArgs f (lib.functionArgs f) // {
    tests = callPackage ./tests {};
  };
}
