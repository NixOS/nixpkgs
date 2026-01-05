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
  xapp-symbolic-icons,
}:

stdenv.mkDerivation rec {
  pname = "bulky";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "bulky";
    tag = version;
    hash = "sha256-BHMCtvnz3Ua4pa3Pnh2PbxZ9a0vJOJ+Se2/DaPbUqQA=";
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
      --replace-fail "/usr/share/locale" "$out/share/locale" \
      --replace-fail /usr/share/bulky "$out/share/bulky" \
      --replace-fail /usr/share/common-licenses "${common-licenses}/share/common-licenses" \
      --replace-fail __DEB_VERSION__  "${version}"
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

  meta = with lib; {
    description = "Bulk rename app";
    mainProgram = "bulky";
    homepage = "https://github.com/linuxmint/bulky";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
