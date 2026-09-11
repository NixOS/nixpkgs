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
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bulky";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "bulky";
    tag = finalAttrs.version;
    hash = "sha256-tEOB5K++yeDpGuV/HMVfB5XKq0O9U4OuaP3dsj2s2/Q=";
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
        python-xapp
        setproctitle
        unidecode
      ]
    ))
    gsettings-desktop-schemas
    gtk3
    glib
    xapp
  ];

  postPatch = ''
    substituteInPlace usr/lib/bulky/bulky.py \
      --replace-fail "/usr/share/locale" "$out/share/locale" \
      --replace-fail /usr/share/bulky "$out/share/bulky" \
      --replace-fail __DEB_VERSION__  "${finalAttrs.version}"
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

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : ${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}
    )
  '';

  meta = {
    description = "Bulk rename app";
    mainProgram = "bulky";
    homepage = "https://github.com/linuxmint/bulky";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
