{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  pkg-config,
  gettext,
  installShellFiles,
  sdl3,
  vulkan-headers,
  vulkan-loader,
  python3,
  qt6,
  steam,
  nix-update-script,
  runCommand,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      babel
      dbus-fast
      evdev
      libarchive-c
      orjson
      pefile
      pillow
      psutil
      pyside6
      qrcode
      rapidfuzz
      requests
      tqdm
      vdf
      websocket-client
    ]
  );

  steam-run = steam.run-free;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "portprotonqt";
  version = "1.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.linux-gaming.ru";
    owner = "Linux-Gaming";
    repo = "PortProtonQt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uBmTAV7T57PhENZZs1MFP/b5ynuJf1szyWPi6uKI12c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    installShellFiles
    python
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    sdl3
    vulkan-headers
    vulkan-loader
    python
    qt6.qtbase
    qt6.qtsvg
  ];

  mesonFlags = [
    (lib.mesonBool "nightly" false)
    (lib.mesonOption "python_purelibdir" "${placeholder "out"}/${python.sitePackages}")
    (lib.mesonOption "udev_rulesdir" "${placeholder "out"}/lib/udev/rules.d")
  ];

  postInstall = ''
    pushd "$NIX_BUILD_TOP/$sourceRoot"
    bash dev-scripts/generate-completions.sh
    installShellCompletion --bash completions/portprotonqt
    installShellCompletion --zsh completions/_portprotonqt
    installShellCompletion --fish completions/portprotonqt.fish
    popd
  '';

  postFixup = ''
    mv $out/bin/portprotonqt $out/bin/.portprotonqt-unwrapped
    makeQtWrapper ${lib.getExe steam-run} $out/bin/portprotonqt \
      --add-flags $out/bin/.portprotonqt-unwrapped \
      --prefix PATH : "${
        lib.makeBinPath [
          "$out"
          python
        ]
      }" \
      --prefix PYTHONPATH : "$out/${python.sitePackages}" \
      --set STEAM_RUNTIME 1 \
      --set STEAM_RUNTIME_PREFER_FRESH 1
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests.smoke =
      runCommand "portprotonqt-smoke-test"
        {
          nativeBuildInputs = [ python ];
        }
        ''
          QT_PLUGIN_PATH="${qt6.qtsvg}/lib/qt-6/plugins" \
            ${python}/bin/python3 -c "import sys; from PySide6.QtCore import QCoreApplication; from PySide6.QtGui import QImageReader; QCoreApplication(sys.argv); assert b'svg' in [bytes(f) for f in QImageReader.supportedImageFormats()], 'SVG image format plugin missing'"
          touch $out
        '';
  };

  meta = {
    description = "Graphical frontend for the PortProton compatibility layer";
    homepage = "https://git.linux-gaming.ru/Linux-Gaming/PortProtonQt";
    changelog = "https://git.linux-gaming.ru/Linux-Gaming/PortProtonQt/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "portprotonqt";
    maintainers = with lib.maintainers; [ dark-siders ];
    platforms = [ "x86_64-linux" ];
  };
})
