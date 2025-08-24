{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  gtk3,
  gspell,
  gmime3,
  gettext,
  intltool,
  itstool,
  libxml2,
  libnotify,
  gnutls,
  wrapGAppsHook3,
  gnupg,
  spellChecking ? true,
  gnomeSupport ? true,
  libsecret,
  gcr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pan";
  version = "0.164";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "pan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fVhjgnDvDf5rmhuW27UpEp3m7o8FFcpakVcGBhBic0Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    intltool
    itstool
    libxml2
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gmime3
    libnotify
    gnutls
  ]
  ++ lib.optionals spellChecking [ gspell ]
  ++ lib.optionals gnomeSupport [
    libsecret
    gcr
  ];

  cmakeFlags = [
    (lib.cmakeBool "WANT_GSPELL" spellChecking)
    (lib.cmakeBool "WANT_GKR" gnomeSupport)
    (lib.cmakeBool "ENABLE_MANUAL" true)
    (lib.cmakeBool "WANT_GMIME_CRYPTO" true)
    (lib.cmakeBool "WANT_WEBKIT" false) # We don't have webkitgtk_3_0
    (lib.cmakeBool "WANT_NOTIFY" true)
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnupg ]})
  '';

  meta = {
    description = "GTK-based Usenet newsreader good at both text and binaries";
    mainProgram = "pan";
    homepage = "http://pan.rebelbase.com";
    maintainers = with lib.maintainers; [
      aleksana
    ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl2Only
      fdl11Only
    ];
  };
})
