{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  makeBinaryWrapper,
  nodejs,
  python3,
  nixosTests,
  yarn-berry_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hedgedoc";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "hedgedoc";
    tag = finalAttrs.version;
    hash = "sha256-sKmy80FO5cp2aKoirtzaPmf2IqTn5yLUkbakIZMa5aQ=";

    # Remove after https://github.com/hedgedoc/hedgedoc/commit/6e6536df1b7b8e1ad30a0929be5b851eef98029f is released
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  # Generate this file with:
  # nix run nixpkgs#yarn-berry_4.yarn-berry-fetcher missing-hashes yarn.lock
  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-OywEJNs1DwUnPPjW2CzEYKhfHz03EcSEJ1PUWx8DGUI=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    (python3.withPackages (ps: with ps; [ setuptools ])) # required to build sqlite3 bindings
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  buildInputs = [
    nodejs # for shebangs
  ];

  buildPhase = ''
    runHook preBuild

    yarn run build

    # Delete scripts that are not useful for NixOS
    rm bin/{heroku,setup}
    patchShebangs bin/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hedgedoc
    cp -r {app.js,bin,lib,locales,node_modules,package.json,public} $out/share/hedgedoc

    for bin in $out/share/hedgedoc/bin/*; do
      makeWrapper $bin $out/bin/$(basename $bin) \
        --set NODE_ENV production \
        --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"
    done
    makeWrapper ${nodejs}/bin/node $out/bin/hedgedoc \
      --add-flags $out/share/hedgedoc/app.js \
      --set NODE_ENV production \
      --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = {
    description = "Realtime collaborative markdown notes on all platforms";
    license = lib.licenses.agpl3Only;
    homepage = "https://hedgedoc.org";
    changelog = "https://github.com/hedgedoc/hedgedoc/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "hedgedoc";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
})
