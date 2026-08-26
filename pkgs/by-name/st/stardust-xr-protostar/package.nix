{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-protostar";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "protostar";
    rev = finalAttrs.version;
    hash = "sha256-mL7LnBvc2B9Y56NCDeNyqIDQsuWb4iMehZ7koR1KkX8=";
  };

  env.STARDUST_RES_PREFIXES = "${finalAttrs.src}/res";

  cargoHash = "sha256-6NiEKm6m4xX6ZSF9Gp7APG/lku3fKoobPSS4AodjCI8=";

  __structuredAttrs = true;
  strictDeps = true;

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prototype application launchers for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
