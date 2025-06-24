{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
}:

rustPlatform.buildRustPackage.override
  (old: {
    cargo = old.cargo.withCommands (c: [ c.cargo-make ]);
  })
  (finalAttrs: {
    pname = "open-scq30";
    version = "1.12.0";

    src = fetchFromGitHub {
      owner = "Oppzippy";
      repo = "OpenSCQ30";
      tag = "v${finalAttrs.version}";
      hash = "sha256-DL2hYm1j27K0nnBvE3iGnguqm0m1k56bkuG+6+u4u4c=";
    };

    nativeBuildInputs = [
      pkg-config
      protobuf
      wrapGAppsHook4
    ];

    buildInputs = [
      cairo
      dbus
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      pango
    ];

    useFetchCargoVendor = true;
    cargoHash = "sha256-3K+/CpTGWSjCRa2vOEcDvLIiZMdntugIqnzkXF4wkng=";

    INSTALL_PREFIX = placeholder "out";

    # Requires headphones
    doCheck = false;

    buildPhase = ''
      cargo make --profile release build
    '';

    installPhase = ''
      cargo make --profile release install
    '';

    meta = {
      description = "Cross platform application for controlling settings of Soundcore headphones";
      homepage = "https://github.com/Oppzippy/OpenSCQ30";
      changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ mkg20001 ];
      mainProgram = "open-scq30";
    };
  })
