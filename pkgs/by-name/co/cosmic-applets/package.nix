{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  util-linuxMinimal,
  dbus,
  glib,
  libinput,
  pulseaudio,
  udev,
  xkeyboard_config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-kRj2hEtE8FYky9Fn8hgHBo+UwWjOoS7/ROh9qz/0Vzs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jADtvhMzWdJydT1T14PSk4ggZpWIcXiOK0TW2llKeos=";

  nativeBuildInputs = [
    just
    pkg-config
    util-linuxMinimal
    libcosmicAppHook
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

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml
      --set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml
    )
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      qyliss
      nyabinary
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
  };
})
