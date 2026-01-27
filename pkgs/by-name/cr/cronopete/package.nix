{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  meson,
  ninja,
  pkg-config,

  cairo,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  libXdmcp,
  libXtst,
  libayatana-appindicator,
  libdatrie,
  libepoxy,
  libgee,
  libnotify,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  pango,
  pcre,
  pcre2,
  udisks,
  util-linuxMinimal,
  rsync,
  vala,
  wrapGAppsHook4,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cronopete";
  version = "4.18.0";

  src = fetchFromGitLab {
    owner = "rastersoft";
    repo = "cronopete";
    tag = finalAttrs.version;
    hash = "sha256-UCYewGxPYq7oZGJ/NZC+rTygGy2+8xNsUBPS7h6+8pE=";
  };

  patches = [
    ./fix-hardcoded-paths.patch
  ];

  strictDeps = true;

  buildInputs = [
    cairo
    gdk-pixbuf
    gtk3
    udisks
    gobject-introspection
    libnotify
    pango
    libayatana-appindicator
    libgee
    pcre2
    util-linuxMinimal # provides libmount
    libselinux
    libsepol
    pcre
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    libepoxy
    libXtst
  ];

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    vala
    makeWrapper
    wrapGAppsHook4
  ];

  postInstall = ''
    wrapProgram $out/bin/cronopete --prefix PATH : ${lib.makeBinPath [ rsync ]}
  '';

  meta = {
    description = "An Apple's TimeMachine clone for Linux";
    homepage = "https://gitlab.com/rastersoft/cronopete";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "cronopete";
  };
})
