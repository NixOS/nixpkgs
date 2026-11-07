{
  stdenv,
  copyDesktopItems,
  autoPatchelfHook,
  wrapGAppsHook4,
  makeDesktopItem,
  libusb1,
  webkitgtk_4_1,
  libsoup_3,
  pname,
  version,
  src,
  meta,
  patchelf,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    copyDesktopItems
    # patchelf 0.19.2 corrupts the binary (NixOS/nixpkgs#577387).
    # FIXME: drop this override once a patchelf release contains
    # https://github.com/NixOS/patchelf/pull/672.
    (patchelf.overrideAttrs (
      finalAttrs: _: {
        version = "0.15.2";
        src = fetchurl {
          url = "https://github.com/NixOS/patchelf/releases/download/${finalAttrs.version}/patchelf-${finalAttrs.version}.tar.bz2";
          hash = "sha256-F3RfVkFZyOIo/EEtplogSLhGxLa0Igt3y/IkFuAvLXw=";
        };
      }
    ))
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libusb1
    webkitgtk_4_1
    libsoup_3
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m755 -D keymapp "$out/bin/keymapp"
    install -Dm644 icon.png "$out/share/icons/keymapp.png"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set-default '__NV_PRIME_RENDER_OFFLOAD' 1)
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "keymapp";
      icon = "keymapp";
      desktopName = "Keymapp";
      categories = [
        "Settings"
        "HardwareSettings"
      ];
      type = "Application";
      exec = "keymapp";
    })
  ];
}
