{
  fetchFromGitHub,
  lib,
  stdenv,
  gobject-introspection,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
  gdk-pixbuf,
  hidapi,
  libappindicator,
  librsvg,
  upower,
  udevCheckHook,
  acl,
}:

# Although we copy in the udev rules here, you probably just want to use
# `logitech-udev-rules`, which is an alias to `udev` output of this derivation,
# instead of adding this to `services.udev.packages` on NixOS,
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "solaar";
  version = "1.1.19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pwr-Solaar";
    repo = "Solaar";
    tag = finalAttrs.version;
    hash = "sha256-Z3rWGmFQmfJvsWiPgxQmfXMPHXAAiFneBaoSVIXnAV8=";
  };

  outputs = [
    "out"
    "udev"
  ];

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udevCheckHook
  ];

  buildInputs = [
    librsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libappindicator
    upower
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      gtk3
      hid-parser
      psutil
      pygobject3
      pyudev
      pyyaml
      typing-extensions
      xlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      evdev
      dbus-python
    ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    pytest-cov-stub
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace lib/solaar/listener.py \
      --replace-fail getfacl "${lib.getExe' acl "getfacl"}"
  '';

  # the -cli symlink is just to maintain compabilility with older versions where
  # there was a difference between the GUI and CLI versions.
  postInstall = ''
    ln -s $out/bin/solaar $out/bin/solaar-cli

    install -Dm444 -t $udev/etc/udev/rules.d rules.d-uinput/*.rules
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : '${lib.makeLibraryPath [ hidapi ]}')
  '';

  env.DYLD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isDarwin (
    lib.makeLibraryPath [ hidapi ]
  );

  pythonImportsCheck = [
    "solaar"
    "solaar.gtk"
  ];

  meta = {
    description = "Linux devices manager for the Logitech Unifying Receiver";
    longDescription = ''
      Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that
      connect wirelessly to a USB Unifying, Lightspeed, or Nano receiver, connect
      directly via a USB cable, or connect via Bluetooth. Solaar does not work with
      peripherals from other companies.

      Solaar can be used as a GUI application or via its command-line interface.

      This tool requires either to be run with root/sudo or alternatively to have the udev rules files installed. On NixOS this can be achieved by setting `hardware.logitech.wireless.enable`.
    '';
    homepage = "https://pwr-solaar.github.io/Solaar/";
    license = lib.licenses.gpl2Only;
    mainProgram = "solaar";
    maintainers = with lib.maintainers; [
      spinus
      ysndr
      oxalica
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
