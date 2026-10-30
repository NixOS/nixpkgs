{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  git,
  gnutar,
  gzip,
  nix-update-script,
  pkg-config,
  qt6,
  steam-run-free,
}:

let
  qtBuildEnv = qt6.env "qt6-rimstack" [ qt6.qtdeclarative ];
  # Tests copy sleep to RimWorld. The multicall binary relies on argv[0],
  # so use a standalone executable.
  testCoreutils = coreutils.override { singleBinary = false; };
  externalRunner = steam-run-free.override { privateTmp = false; };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rimstack";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TheForgotten69";
    repo = "RimStack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VWPZxpJLocKm43gcIN0dNGIMS2tBFYETKa1+9+ubbvE=";
  };

  cargoHash = "sha256-BedPTyvZXEr+9DGoiuIErEsBSjw4Vc5Vsqpq3t9StDQ=";

  patches = [
    ./disable-desktop-install.patch
    ./steam-run.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace \
      crates/app/src/workspace/load_order/tests.rs \
      crates/core/src/sources/maintenance.rs \
      --replace-fail '"/bin/sleep"' '"${lib.getExe' testCoreutils "sleep"}"'
  '';

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  nativeCheckInputs = [ git ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # This test compares path spelling on a case-insensitive filesystem.
    "--skip=rimworld::about::tests::about_is_located_whatever_its_case"
    # These tests use Linux installation paths with the host's OS detection.
    "--skip=rimworld::paths::tests::game_in_a_second_library_is_found_and_symlinked_roots_count_once"
    "--skip=rimworld::paths::tests::library_listing_the_app_beats_a_stale_copy"
    "--skip=rimworld::paths::tests::native_install_is_found"
    "--skip=rimworld::paths::tests::proton_settings_are_found"
    "--skip=rimworld::paths::tests::steam_s_list_of_libraries_is_read_from_either_place_it_keeps_it"
    # SteamCMD is disabled upstream on macOS.
    "--skip=sources::redownload::tests::a_download_is_taken_from_this_run_s_own_folder_when_steamcmd_says_it_succeeded"
    "--skip=sources::redownload::tests::an_earlier_download_left_in_the_scratch_is_not_taken_for_a_failed_one"
    "--skip=sources::redownload::tests::one_run_tells_each_item_s_own_outcome"
    "--skip=sources::redownload::tests::only_a_number_is_asked_of_steamcmd"
    "--skip=sources::redownload::tests::steamcmd_is_run_with_a_home_of_its_own_never_the_user_s"
  ];

  # CXX-Qt needs a shared Qt prefix. Use qmake from qtBuildEnv.
  # Set QMAKE here because the Qt setup hook overwrites it.
  preConfigure = ''
    export QMAKE=${qtBuildEnv}/bin/qmake
  '';

  env = {
    QT_QPA_PLATFORM = "offscreen";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-F${qtBuildEnv}/lib";
  };

  postInstall = ''
    install -Dm644 crates/app/assets/rimstack.desktop $out/share/applications/rimstack.desktop
    install -Dm644 crates/app/assets/rimstack.svg $out/share/icons/hicolor/scalable/apps/rimstack.svg
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      git
      gnutar
      gzip
    ])
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--set"
    "RIMSTACK_LAUNCHER"
    (lib.getExe externalRunner)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast mod manager for RimWorld";
    homepage = "https://github.com/TheForgotten69/RimStack";
    changelog = "https://github.com/TheForgotten69/RimStack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      neolouker
      adda
    ];
    mainProgram = "rimstack";
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
})
