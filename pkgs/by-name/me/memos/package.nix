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
  version = "0.29.0";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l9jyByfVCx+z41H+RVgkggjkVSoleHq+mR6nhgk9Pj8=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalWebAttrs: {
    pname = "memos-web";
    inherit (finalAttrs) version src;
    pnpmDeps = fetchPnpmDeps {
      inherit (finalWebAttrs) pname version src;
      inherit pnpm;
      sourceRoot = "${finalWebAttrs.src.name}/web";
      fetcherVersion = 3;
      hash = "sha256-Ki9rC1i0gvz+4La0GZIF40mZPwv/EwzhHUaealSpU40=";
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

  vendorHash = "sha256-6oJgxhGS7aD3I0umTQuVMLzcOhzf53g4TZcCtkKrrc8=";

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
