{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  cacert,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfait";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5O6+bsfoNC52+YTgptfH8Rv7IORN/m2MwzXh39ofXk=";
  };

  nativeCheckInputs = [
    cacert
  ];

  cargoHash = "sha256-t+Ppfw+Zx1fXOksm9IXxrvR6Qoy9bhuEVGtcwrTwD00=";
  buildFeatures = [ "gui" ];
  cargoBuildFlags = [
    "--bin"
    "cfait"
    "--bin"
    "cfait-gui"
  ];

  outputs = [
    "out"
    "gui"
  ];

  postInstall = ''
    mkdir -p $gui/bin
    mv $out/bin/cfait-gui $gui/bin/cfait-gui
  '';
  # Wayland and X11 libs are required at runtime only for cfait-gui since winit uses dlopen
  postFixup = ''
    patchelf $gui/bin/cfait-gui --add-rpath "${
      lib.makeLibraryPath [
        wayland
        libx11
        libxcursor
        libxi
        libxkbcommon
      ]
    }"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.+)"
    ];
  };

  meta = {
    description = "CalDAV task manager for power users";
    homepage = "https://codeberg.org/trougnouf/cfait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "cfait";
    platforms = lib.platforms.all;
  };
})
