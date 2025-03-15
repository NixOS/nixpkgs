{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  versionCheckHook,
  writeShellApplication,
  libdovi,
  nixVersions,
  nix-update,
  tomlq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dovi-tool";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = finalAttrs.version;
    hash = "sha256-z783L6gBr9o44moKYZGwymWEMp5ZW7yOhZcpvbznXK4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pwB6QBLeHALbYZHzTBm/ODLPHhxM3B5n+B/0iXYNuVc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  checkFlags = [
    # fails because nix-store is read only
    "--skip=rpu::plot::plot_p7"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/dovi_tool";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-${finalAttrs.pname}";
    runtimeInputs = [
      nixVersions.latest
      nix-update
      tomlq
    ];

    text = ''
      nix-update ${finalAttrs.pname}
      src="$(nix eval -f . --raw ${finalAttrs.pname}.src)"
      libver="$(tq -f "$src/dolby_vision/Cargo.toml" package.version)"
      nix-update ${libdovi.pname} --version "$libver"
    '';
  });

  meta = {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    changelog = "https://github.com/quietvoid/dovi_tool/releases";
    mainProgram = "dovi_tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ plamper ];
  };
})
