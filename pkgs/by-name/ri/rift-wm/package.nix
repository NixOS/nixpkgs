{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.8.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cLFGVkPF7qGgC4QIyEc8b9rZ0LB8PoH7golgwT59ZRA=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-XFn/DXOimu4gkgOXKDgZ/RBVxida7mvq1+lMx0Wrt/4=";

  useNextest = true;
  dontUseCargoParallelTests = true;

  cargoTestFlags = [
    "-E"
    (lib.concatMapStringsSep " & " (test: "not test(${test})") [
      # 156 of these 290 tests time out; the other 134 pass. The full upstream
      # suite passes outside the Nix build environment, so skip this module here.
      "actor::reactor::tests::"

      # These animation and gesture tests also hang in the Nix Darwin build environment.
      "actor::reactor::animation::tests::display_transfer_resets_scrolling_frames_and_preserves_tiling"
      "actor::reactor::animation::tests::space_snapshot_preserves_animation_until_presentation_changes"
      "actor::reactor::gesture::tests::live_scroll_coalesces_app_writes_and_reconciles_once_at_lift"

      # CoreText uses fallback fonts in the builder, changing the expected label width.
      "ui::menu_bar::layout_library_tests::labels_use_cached_text_width_for_numbers_and_names"
    ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macOS with configurable layouts and virtual workspaces";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      eveeifyeve
      pixelcmnd
    ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
