{
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
}:
let
  version = "0.26.1";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-DnUrrBB6f6Y77uiiGRc/lcPAGfP+qlNsN5KWIlB+lzY=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-6lrXpblVY7Q7UMMU0obVAwACodW+WJm/INiSMPzEgEI=";
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
in
buildGoModule {
  pname = "memos";
  inherit version src memos-web;

  vendorHash = "sha256-bQA+3IRgcjlYHpPdJNl/rfWHk25xsclFW5kNM/zO4/Y=";

  preBuild = ''
    rm -rf server/router/frontend/dist
    cp -r ${memos-web} server/router/frontend/dist
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "memos-web"
    ];
  };

  doCheck = false;

  meta = {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    changelog = "https://github.com/usememos/memos/releases/tag/${src.rev}";
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
}
