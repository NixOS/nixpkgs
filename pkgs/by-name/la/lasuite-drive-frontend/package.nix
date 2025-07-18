{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-drive-frontend";
  version = "unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    rev = "fd36f04c5b604977989327b3ee675a77f28ecd9f";
    hash = "sha256-RXGqlcqFkulGVdEyIosZhyGmcxwMDWFdT6q6P5QFxXs=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-xKlowV7TKABQvuXO9QhK2rOpqAmgWRN7z4vZJDuitP8=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
  ];

  prePatch = ''
    substituteInPlace apps/drive/package.json \
      --replace-fail '"posthog-js": "1.255.0"' '"posthog-js": "^1.255.0"'
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r apps/drive/out/ $out

    runHook postInstall
  '';

  meta = {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
