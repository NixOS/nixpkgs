{
  dbus,
  fetchFromGitHub,
  glib,
  just,
  lib,
  libcosmicAppHook,
  libinput,
  pkg-config,
  pulseaudio,
  rustPlatform,
  stdenv,
  udev,
  util-linux,
  xkeyboard_config,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-77sCLHN4U+9WgX5h0skrkEiIy5Nl2FwGNuuY3O7X7D4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8wyahm42d4dyrzxvexunLsbSvQB/IkN1wRjgv3i1W38=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
    util-linux
  ];

  buildInputs = [
    dbus
    glib
    libinput
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;

    maintainers = with maintainers; [
      nyabinary
      qyliss
      thefossguy
    ];
  };
}
