{
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
}:
let
  pnpm = pnpm_10;
in
buildGoModule (finalAttrs: {
  pname = "memos";
  version = "0.25.3";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lAKzPteGjGa7fnbB0Pm3oWId5DJekbVWI9dnPEGbiBo=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalWebAttrs: {
    pname = "memos-web";
    inherit (finalAttrs) version src;
    pnpmDeps = fetchPnpmDeps {
      inherit (finalWebAttrs) pname version src;
      inherit pnpm;
      sourceRoot = "${finalWebAttrs.src.name}/web";
      fetcherVersion = 3;
      hash = "sha256-xEOnxCgBD4uLypcZzCO+31S4r0sSfz8PpgEmZASeRZ4=";
    };
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];
    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });

  vendorHash = "sha256-BoJxFpfKS/LByvK4AlTNc4gA/aNIvgLzoFOgyal+aF8=";

  ldflags = [
    "-X github.com/usememos/memos/internal/version.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    rm -rf server/router/frontend/dist
    cp -r ${finalAttrs.memos-web} server/router/frontend/dist
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "memos-web"
    ];
  };

  meta = {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    changelog = "https://github.com/usememos/memos/releases/tag/${finalAttrs.src.rev}";
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
})
