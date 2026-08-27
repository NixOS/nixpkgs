{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  autoreconfHook,
  intltool,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,

  # buildInputs
  libxml2,
  pciutils,
  gtk3,
  ddccontrol-db,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddccontrol";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    tag = finalAttrs.version;
    sha256 = "sha256-8VqnmWLXt6rXapAqvzvtDQ9XjQ7H6s7pLqPhQ6Zflc4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-UN308Tt9LCRLBSswem06UupjdIFntt6SqpTxteY5O78=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    libxml2
    pciutils
    gtk3
    ddccontrol-db
  ];

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  prePatch = ''
    substituteInPlace configure.ac \
      --replace-fail \
      "\$""{datadir}/ddccontrol-db" \
      "${ddccontrol-db}/share/ddccontrol-db"
    substituteInPlace src/lib/Makefile.am \
      --replace-fail \
      'DDCONTROL_DATADIR="$(datadir)/ddccontrol-db"' \
      'DDCONTROL_DATADIR="${ddccontrol-db}/share/ddccontrol-db"'
  '';

  preConfigure = ''
    intltoolize --force
  '';

  meta = {
    description = "Program used to control monitor parameters by software";
    homepage = "https://github.com/ddccontrol/ddccontrol";
    mainProgram = "ddccontrol";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pakhfn
      doronbehar
    ];
  };
})
