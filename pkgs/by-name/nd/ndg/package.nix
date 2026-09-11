{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ndg";
  version = "2.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "ndg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tgZeZOK8rpaN0QiUtWQTMrd04kWRT+EV6MdNUzZUy/4=";
  };

  cargoHash = "sha256-lB/GmlFaXLfmwRMgSvFtgrsl+GFMGlUGF8SnDCD3o1I=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "-p"
    "ndg"
    "-p"
    "xtask"
  ];

  checkFlags = [
    "--skip"
    "test_js_commonjs_syntax"
  ];

  postInstall =
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in
      ''
        ${emulator} $out/bin/xtask dist

        installManPage dist/man/*
        installShellCompletion --cmd ${finalAttrs.meta.mainProgram} dist/completions/*.{bash,fish,zsh}
      ''
    )
    + ''
      rm $out/bin/xtask
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Not A Docs Generator";
    homepage = "https://github.com/feel-co/ndg";
    changelog = "https://github.com/feel-co/ndg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "ndg";
    teams = [ lib.teams.feel-co ];
  };
})
