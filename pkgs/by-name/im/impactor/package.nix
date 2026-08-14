{
  atk,
  autoPatchelfHook,
  cairo,
  dbus,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  lib,
  libappindicator,
  libayatana-appindicator,
  libgit2,
  libimobiledevice,
  libimobiledevice-glue,
  libsoup_3,
  makeWrapper,
  openssl,
  pango,
  pkg-config,
  rustPlatform,
  usbmuxd,
  zenity,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impactor";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "claration";
    repo = "Impactor";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ahKJ3NRZvyLhhEYtH0fB2s7yF3HsD3WrTaA1O1knFsg=";
  };

  cargoHash = "sha256-W5AKdOjUOtggDnzKno4U40DXbComVUj0mFXRcQ8abqc=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libappindicator
    libayatana-appindicator
    libgit2
    libimobiledevice
    libimobiledevice-glue
    libsoup_3
    openssl
    pango
    usbmuxd
    zenity
    zlib
  ];

  propaguatedBuildInputs = [
    libimobiledevice
    libimobiledevice-glue
    usbmuxd
    zenity
  ];

  postInstall = ''
    mv $out/bin/plumeimpactor $out/bin/impactor
    wrapProgram $out/bin/impactor \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libappindicator
          libayatana-appindicator
          libimobiledevice
          libimobiledevice-glue
          libsoup_3
          usbmuxd
          zenity
        ]
      } \
      --prefix PATH : ${
        lib.makeBinPath [
          libimobiledevice
          libimobiledevice-glue
          usbmuxd
          zenity
        ]
      }
  '';

  meta = {
    description = "Feature rich iOS/tvOS sideloading application written in Rust.";
    homepage = "https://github.com/claration/Impactor";
    maintainers = with lib.maintainers; [ idkdontaskm3 ];
    mainProgram = "impactor";
    license = with lib.licenses; [
      mit
      bsd3
    ];
  };
})
