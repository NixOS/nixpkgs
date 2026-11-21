{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

let
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "BenTheCyberOne";
    repo = "Copperhound";
    tag = "v${version}";
    hash = "sha256-QiJvyNokE7JgG30webLFVOA0zb/knLZ3BVPlvJudGtU=";
  };

  web = buildNpmPackage {
    pname = "copperhound-web";
    inherit version src;

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-izcREqnAns84pcP6OkVdySC6IpPwX9ynKGo8mPZckg4=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "copperhound";
  inherit version src;

  __structuredAttrs = true;

  cargoHash = "sha256-H81dejwFVsS4KFSt6bewLtEoILOY5EnvKD3R0D40Lcs=";

  nativeBuildInputs = [ makeWrapper ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  postInstall = ''
    wrapProgram $out/bin/copperhound \
      --set COPPERHOUND_WEB_DIR ${web}
  '';

  passthru = {
    inherit web;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Attack-path analysis for AD, ADCS and Entra ID";
    homepage = "https://github.com/BenTheCyberOne/Copperhound";
    changelog = "https://github.com/BenTheCyberOne/Copperhound/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "copperhound";
  };
})
