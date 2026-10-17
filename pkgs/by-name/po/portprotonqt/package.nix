{
  lib,
  stdenv,
  fetchurl,
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
  # The meson build installs the `portprotonqt` package into $out; this
  # interpreter supplies the third-party modules it imports at runtime.
  # `withPackages` is required because the application is started from an FHS
  # sandbox that replaces PATH, so the interpreter must carry its whole module
  # closure (transitive dependencies included) instead of relying on PYTHONPATH.
  python = python3.withPackages (
    ps: with ps; [
      pyside6
      shiboken6
      orjson
      babel
      dbus-fast
      pillow
      vdf
      requests
      tqdm
      pefile
      websocket-client
      psutil
      evdev
      libarchive-c
      rapidfuzz
      qrcode
    ]
  );

  # PortProton's shell scripts assume a conventional filesystem layout (glibc,
  # bash, coreutils under /bin and /usr), which NixOS does not provide.
  # steam.run-free supplies that FHS without depending on the unfree Steam
  # client; the freedesktop runtime it is built on already ships everything the
  # launcher needs.
  steam-run = steam.run-free;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "portprotonqt";
  version = "1.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://git.linux-gaming.ru/Linux-Gaming/PortProtonQt/archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-oJJwy9KcAnepFmul/TCEWYyJkuQWCckdfIewjxLnMGg=";
  };

  # `python` also appears in buildInputs: with strictDeps the entry point's
  # shebang is resolved from the runtime closure, while meson needs python3 in
  # the build PATH (the meson hook does not propagate ninja either).
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    installShellFiles
    python
    # Provides makeQtWrapper, used below to put the Qt plugin paths (notably the
    # SVG image-format plugin) on QT_PLUGIN_PATH.
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    sdl3
    vulkan-headers
    vulkan-loader
    python
    # Qt draws the checkbox checkmarks from SVG assets bundled with the
    # application; loading those needs the SVG image-format plugin, which lives
    # in qtsvg (PySide6 ships no Qt plugins of its own).
    qt6.qtbase
    qt6.qtsvg
  ];

  mesonFlags = [
    # The sources come from a release tarball, not a git checkout, so embedding
    # the commit would only yield an "unknown" marker.
    (lib.mesonBool "nightly" false)
    # Without an explicit purelibdir meson derives it from the interpreter's
    # sysconfig and tries to install into the read-only interpreter store path.
    (lib.mesonOption "python_purelibdir" "${placeholder "out"}/${python.sitePackages}")
    # Install the udev rule under $out instead of the absolute /lib/udev.
    (lib.mesonOption "udev_rulesdir" "${placeholder "out"}/lib/udev/rules.d")
  ];

  postInstall = ''
    # The release tarball does not ship the generated shell completions. The
    # generator writes them next to the (unpacked) sources, while the meson
    # install phase runs from the build directory, so reference the source root
    # explicitly.
    pushd "$NIX_BUILD_TOP/$sourceRoot"
    bash dev-scripts/generate-completions.sh
    installShellCompletion --bash completions/portprotonqt
    installShellCompletion --zsh completions/_portprotonqt
    installShellCompletion --fish completions/portprotonqt.fish
    popd
  '';

  postFixup = ''
    mv $out/bin/portprotonqt $out/bin/.portprotonqt-unwrapped

    # makeQtWrapper is makeWrapper plus the Qt environment gathered from the Qt
    # packages in buildInputs (QT_PLUGIN_PATH, the QML import path) and the
    # package's own $out/share, wrapping the FHS launcher that PortProton's
    # shell scripts require.
    makeQtWrapper ${lib.getExe steam-run} $out/bin/portprotonqt \
      --add-flags $out/bin/.portprotonqt-unwrapped \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ python ]}" \
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
          cp -r ${finalAttrs.finalPackage} $out
          chmod -R u+w -- $out

          # The application writes its cache and configuration into XDG
          # directories; redirect them into the sandbox.
          export HOME=$TMPDIR/home
          export XDG_CONFIG_HOME=$HOME/.config
          export XDG_CACHE_HOME=$HOME/.cache
          export XDG_DATA_HOME=$HOME/.local/share
          export XDG_STATE_HOME=$HOME/.local/state
          mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

          # The wrapper has to go through the FHS and add the package to the
          # interpreter's module search path.
          grep -q "steam-run" "$out/bin/portprotonqt"
          grep -q "${python.sitePackages}" "$out/bin/portprotonqt"

          # Qt draws the checkbox checkmarks from bundled SVG assets, which only
          # works while the SVG image-format plugin is on QT_PLUGIN_PATH.
          grep -q "QT_PLUGIN_PATH" "$out/bin/portprotonqt"
          grep -q "${qt6.qtsvg}/lib/qt-6/plugins" "$out/bin/portprotonqt"
          QT_PLUGIN_PATH="${qt6.qtsvg}/lib/qt-6/plugins" \
            ${python}/bin/python3 -c "import sys; from PySide6.QtCore import QCoreApplication; from PySide6.QtGui import QImageReader; QCoreApplication(sys.argv); assert b'svg' in [bytes(f) for f in QImageReader.supportedImageFormats()], 'SVG image format plugin missing'"

          # The NixOS support below is provided by upstream and must survive
          # version bumps: the engine scripts defer to PORTPROTONQT_PYTHON, which
          # app.py points at its own (correct) interpreter, and kill_portwine()
          # avoids killing the wrapper's own container.
          for f in "$out/share/portproton/scripts/start.sh" \
                   "$out/share/portproton/scripts/functions_helper"; do
            grep -q 'PORTPROTONQT_PYTHON:-python3' "$f"
            bash -n "$f"
          done
          grep -q 'PORTPROTONQT_PYTHON.*=.*sys.executable' \
            "$out/${python.sitePackages}/portprotonqt/app.py"
          grep -q "pw_ancestor_pid" "$out/share/portproton/scripts/functions_helper"

          # The CLI must start and the compiled modules must load in exactly the
          # interpreter the engine helpers are told to use.
          PYTHONPATH="$out/${python.sitePackages}" \
            "$out/bin/.portprotonqt-unwrapped" --help > help.txt
          grep -q "PortProtonQt CLI" help.txt
          ${python}/bin/python3 -c "import orjson, babel"
        '';
  };

  meta = {
    description = "Graphical frontend for the PortProton compatibility layer";
    homepage = "https://git.linux-gaming.ru/Linux-Gaming/PortProtonQt";
    changelog = "https://git.linux-gaming.ru/Linux-Gaming/PortProtonQt/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "portprotonqt";
    maintainers = with lib.maintainers; [ dark-siders ];
    # The launcher depends on steam.run-free, which only exists on x86_64-linux.
    platforms = [ "x86_64-linux" ];
  };
})
