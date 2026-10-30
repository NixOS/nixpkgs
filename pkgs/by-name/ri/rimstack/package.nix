{
  lib,
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

  postPatch = ''
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
    qt6.qtwayland
  ];

  nativeCheckInputs = [ git ];

  # CXX-Qt needs a shared Qt prefix. Use qmake from qtBuildEnv.
  # Set QMAKE here because the Qt setup hook overwrites it.
  preConfigure = ''
    export QMAKE=${qtBuildEnv}/bin/qmake
  '';

  env.QT_QPA_PLATFORM = "offscreen";

  postInstall = ''
    install -Dm644 crates/app/assets/rimstack.desktop $out/share/applications/rimstack.desktop
    install -Dm644 crates/app/assets/rimstack.svg $out/share/icons/hicolor/scalable/apps/rimstack.svg
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          git
          gnutar
          gzip
        ]
      }
      --set RIMSTACK_LAUNCHER ${lib.getExe externalRunner}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mod manager for RimWorld";
    homepage = "https://github.com/TheForgotten69/RimStack";
    changelog = "https://github.com/TheForgotten69/RimStack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ neolouker ];
    mainProgram = "rimstack";
    platforms = [ "x86_64-linux" ];
  };
})
