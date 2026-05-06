{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-protostar";
  version = "0.51.1-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "protostar";
    rev = "4f2f5b032280ea391bf5e7af9b13ab5e0eb21340";
    hash = "sha256-pnvJh52mumi79bZ6Rrm0LpoRf5j041uA9JdUI0n+6f0=";
  };

  env.STARDUST_RES_PREFIXES = "${finalAttrs.src}/res";

  cargoHash = "sha256-7Bz6LGXxNhZvIk/VqU/r97DM5tByl/cSq7h8/sLXpn8=";

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
})
