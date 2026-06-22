{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  xdotool,
  kdotool,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mouser";
  version = "3.6.0";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TomBadash";
    repo = "Mouser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ESfkpswENa91wL1WSfDL/Wpu4sjhT8qibJ0wsEYHX+0=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  dependencies =
    (with python3Packages; [
      pyside6
      hidapi
      pillow
    ])
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      with python3Packages;
      [
        evdev
      ]
    );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mouser
    cp -r main_qml.py core ui images $out/share/mouser/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 images/logo_icon.png $out/share/pixmaps/mouser.png
    install -Dm444 packaging/linux/69-mouser-logitech.rules \
      -t $out/lib/udev/rules.d
  ''
  + ''
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/mouser \
      --prefix PYTHONPATH : "$PYTHONPATH" \
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    --prefix PATH : "${
      lib.makeBinPath [
        xdotool
        kdotool
      ]
    }" \
  ''
  + ''
    --add-flags "$out/share/mouser/main_qml.py"
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "mouser";
      desktopName = "Mouser";
      comment = "Logitech mouse remapper";
      exec = "mouser";
      icon = "mouser";
      terminal = false;
      categories = [
        "Settings"
        "Utility"
      ];
      keywords = [
        "mouse"
        "logitech"
        "buttons"
        "remap"
      ];
      startupWMClass = "Mouser";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight local alternative to Logitech Options+ for remapping HID++ mice";
    longDescription = ''
      Mouser is a fully-local, open-source alternative to Logitech Options+ for
      remapping Logitech HID++ mice (MX Master / MX Anywhere families and other
      Logitech devices). It supports per-application profiles, DPI / Smart Shift
      control, scroll direction inversion, and gesture-button swipes.

      On NixOS, add the package to `services.udev.packages` so the bundled
      `69-mouser-logitech.rules` is loaded and the active local session can access
      `/dev/hidraw*`, `/dev/input/event*`, and `/dev/uinput` without root.
    '';
    homepage = "https://github.com/TomBadash/Mouser";
    changelog = "https://github.com/TomBadash/Mouser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mouser";
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
