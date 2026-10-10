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
  version = "0.7.33";

  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nqemseOqkEIrh2WhuRNHY375Y7w7lqUAPYeAZq4WWyw=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  cargoHash = "sha256-5caBXqy95K/ljrKL4/TKBQpi9cTCmu45ZhRShD1Zg3c=";

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
