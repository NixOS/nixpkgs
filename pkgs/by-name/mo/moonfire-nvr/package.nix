{
  lib,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  sqlite,
  testers,
  moonfire-nvr,
  nix-update,
  writeShellApplication,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moonfire-nvr";
  version = "0.7.31";

  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QgsaiWcXeU4y7z9mcqUAl4mQ/M4p38yRjOB/4MKlpVA=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  cargoHash = "sha256-TDFe5pD+8eSwvw0h9GLM+JfODlSBU1CO8fw4FVjy8xk=";

  env.VERSION = "v${finalAttrs.version}";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/lib
    ln -s ${moonfire-nvr.ui} $out/lib/ui
  '';

  doCheck = false;

  passthru = {
    ui = callPackage ./ui.nix { };
    tests.version = testers.testVersion {
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
      version = "Version: v${finalAttrs.version}";
    };
    updateScript = lib.getExe (writeShellApplication {
      name = "update-moonfire-nvr";

      runtimeInputs = [
        nix-update
      ];

      text = ''
        set -euo pipefail

        nix-update moonfire-nvr
        nix-update moonfire-nvr.ui --version=skip
      '';
    });
  };

  meta = {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "moonfire-nvr";
  };
})
