{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook3,
  python3,
  gobject-introspection,
  gsettings-desktop-schemas,
  gettext,
  gtk3,
  glib,
  common-licenses,
}:

stdenv.mkDerivation rec {
  pname = "bulky";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "bulky";
    rev = version;
    hash = "sha256-LrArLx0AOEaeAvLBVhV9ho5H+qeiaBfjs8+iV5W9u+w=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gsettings-desktop-schemas
    gettext
    gobject-introspection
  ];

  buildInputs = [
    (python3.withPackages (
      p: with p; [
        pygobject3
        setproctitle
        unidecode
      ]
    ))
    gsettings-desktop-schemas
    gtk3
    glib
  ];

  postPatch = ''
    substituteInPlace usr/lib/bulky/bulky.py \
                     --replace "/usr/share/locale" "$out/share/locale" \
                     --replace /usr/share/bulky "$out/share/bulky" \
                     --replace /usr/share/common-licenses "${common-licenses}/share/common-licenses" \
                     --replace __DEB_VERSION__  "${version}"
  '';

  installPhase = ''
    runHook preInstall
    chmod +x usr/share/applications/*
    cp -ra usr $out
    ln -sf $out/lib/bulky/bulky.py $out/bin/bulky
    runHook postInstall
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Bulk rename app";
    mainProgram = "bulky";
    homepage = "https://github.com/linuxmint/bulky";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
