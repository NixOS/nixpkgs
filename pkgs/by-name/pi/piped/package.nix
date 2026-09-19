{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2026-08-26";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "e341724a3f5fe46d9f318e8acba207688f1045de";
    hash = "sha256-hOZHr4r/1ITTr1vEWpZNU2erDDtvQ5nA02Y+8oaJvME=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist "$out"

    runHook postInstall
  '';

  strictDeps = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-mBEzm+GzF/V3W/6JPOn81YawAMaSTw8THtOUb3qtmvc=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.SchweGELBin ];
    license = lib.licenses.agpl3Plus;
  };

})
