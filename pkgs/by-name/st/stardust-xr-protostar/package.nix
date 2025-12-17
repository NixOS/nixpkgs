{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-protostar";
  version = "0.50.0-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "protostar";
    rev = "7609cbfc07121b3b68d91bf2124b9c0afa57363d";
    hash = "sha256-rS7wG6cuhWrHycIMg0gZJR14p1+flTprOiTyrJ5ldAs=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoHash = "sha256-8hHmK6JM1SZjggaq4+iYQKdMLVnFR2Up/jn2qCesLrI=";

  checkFlags = [
    # ---- xdg::test_get_desktop_files stdout ----
    # thread 'xdg::test_get_desktop_files' panicked at protostar/src/xdg.rs:98:5:
    # assertion failed: desktop_files.iter().any(|file|
    #    file.ends_with("com.belmoussaoui.ashpd.demo.desktop"))
    "--skip=xdg::test_get_desktop_files"

    # ---- xdg::test_get_icon_path stdout ----
    # thread 'xdg::test_get_icon_path' panicked at protostar/src/xdg.rs:355:38:
    # Could not create image cache directory: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    # note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    "--skip=xdg::test_get_icon_path"

    # ---- xdg::test_render_svg_to_png stdout ----
    # thread 'xdg::test_render_svg_to_png' panicked at protostar/src/xdg.rs:355:38:
    # Could not create image cache directory: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    "--skip=xdg::test_render_svg_to_png"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Prototype application launchers for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
