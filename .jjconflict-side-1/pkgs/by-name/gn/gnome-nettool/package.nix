{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  glib,
  gtk3,
  libgtop,
  dnsutils,
  iputils,
  nmap,
  inetutils,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-nettool";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nettool/${lib.versions.major version}/gnome-nettool-${version}.tar.xz";
    hash = "sha256-pU8p7vIDiu5pVRyLGcpPdY5eueIJCkvGtWM9/wGIdR8=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.gnome.org/GNOME/gnome-nettool/-/merge_requests/3
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-nettool/-/commit/1124c3e1fdb8472d30b7636500229aa16cdc1244.patch";
      hash = "sha256-fbpfL8Xb1GsadpQzAdmu8FSPs++bsGCVdcwnzQWttGY=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgtop
  ];

  postPatch = ''
    chmod +x postinstall.py
    patchShebangs postinstall.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          dnsutils # for dig
          iputils # for ping
          nmap # for nmap
          inetutils # for ping6, traceroute, whois
        ]
      }"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-nettool"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-nettool";
    description = "Collection of networking tools";
    mainProgram = "gnome-nettool";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
