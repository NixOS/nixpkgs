{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildNpmPackage,
  pkg-config,
  libsecret,
}:

buildNpmPackage rec {
  pname = "lasuite-meet-frontend";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "meet";
    tag = "v${version}";
    hash = "sha256-18DcrrEvqWR6caEVZYxQlSnKcxItEpNE+bMhtS4Aa0M=";
  };

  sourceRoot = "source/src/addons/outlook";

  npmDeps = fetchNpmDeps {
    inherit version src;
    sourceRoot = "source/src/addons/outlook";
    hash = "sha256-ReYXXYFzqZl0HWAgLdlw25ZamZJ06Aez8g1Tv/Nt3cE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsecret
  ];

  buildPhase = ''
    runHook preBuild

    npm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Microsoft Outlook add-in support for LaSuite Meet";
    homepage = "https://github.com/suitenumerique/meet";
    changelog = "https://github.com/suitenumerique/meet/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
