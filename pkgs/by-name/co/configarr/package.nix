{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "configarr";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "raydak-labs";
    repo = "configarr";
    tag = "v1.13.4";
    hash = "sha256-hfP1hrqK/ueuY4ll1Cr4msdJO0yu/mVTVYLP+u/xB5U=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeBinaryWrapper
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NYq8nLML2C1ZgxecmchyeaC3sRsUSgRjwLto84yqboI=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    pnpm test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share bundle.cjs

    makeWrapper ${lib.getExe nodejs} $out/bin/configarr \
      --add-flags "$out/share/bundle.cjs"

    runHook postInstall
  '';

  meta = {
    description = "Sync TRaSH Guides + custom configs with Sonarr/Radarr";
    homepage = "https://github.com/raydak-labs/configarr";
    changelog = "https://github.com/raydak-labs/configarr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lord-valen ];
    mainProgram = "configarr";
    platforms = lib.platforms.all;
  };
})
