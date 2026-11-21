{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  installShellFiles,
  copyDesktopItems,
  pkg-config,
  aws-lc,
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    # copy only runtime/ to keep the source out of the closure
    defaultRuntimeDir = runCommand "mitos-default-runtime" { } ''
      cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
      rm -rf $out/grammars
    '';
  in
  {
    pname = "mitos-unwrapped";
    version = "0.2.1";

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "mitos-editor";
      repo = "mitos";
      tag = "v${finalAttrs.version}";
      hash = "sha256-t2FLmuFm0MNBgxTxoLv6ViYP3o3Oyk5ONI9XwUqH37Q=";
    };

    cargoHash = "sha256-iLU+zt9gQXAp5uO/9/dCfE9FtiuAhIdrUgJguZYee7g=";

    nativeBuildInputs = [
      installShellFiles
      copyDesktopItems
      pkg-config
    ];
    buildInputs = [ aws-lc ];
    nativeCheckInputs = [ git ];
    useNextest = true;

    # these need grammars, which are only added by the mitos wrapper
    checkFlags =
      lib.concatMap
        (t: [
          "--skip"
          t
        ])
        [
          "application::render::tests::opening_a_file_publishes_ready_syntax_before_input_frame"
          "application::render::tests::ready_syntax_is_published_before_first_frame"
          "application::render::tests::syntax_finishing_during_grace_is_in_the_first_frame"
          "application::render::tests::syntax_grace_includes_newly_visible_unfocused_splits"
          "ui::editor::render::syntax_cache::rendering_tests::publication_and_geometry_changes_match_fresh_rendering"
          "ui::markdown::tests::code_spans_preserve_unicode_overlays_tabs_and_line_endings"
          "ui::picker::preview::syntax_preview_tests::cached_previews_refresh_language_resources_and_ignore_old_results"
          "ui::picker::preview::syntax_preview_tests::changing_selection_cancels_the_previous_preview_and_allows_returning"
          "ui::picker::preview::syntax_preview_tests::preview_highlights_after_50_ms_without_restarting_or_switching_queues"
          "ui::picker::preview::syntax_preview_tests::queued_results_cannot_publish_to_hidden_or_replaced_previews"
          "ui::picker::preview::syntax_preview_tests::replacement_preserves_highlighted_preview"
        ];

    env = {
      # don't fetch grammars in build.rs
      MITOS_DISABLE_AUTO_GRAMMAR_BUILD = "1";
      MITOS_DEFAULT_RUNTIME = defaultRuntimeDir;
    };

    desktopItems = [ "${finalAttrs.src}/contrib/Mitos.desktop" ];

    postInstall = ''
      installShellCompletion contrib/completion/ms.{bash,fish,zsh}
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    meta = {
      description = "Fast and minimal modal text editor, forked from Helix";
      homepage = "https://github.com/mitos-editor/mitos";
      changelog = "https://github.com/mitos-editor/mitos/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.mpl20;
      mainProgram = "ms";
      maintainers = with lib.maintainers; [ giomf ];
    };
  }
)
