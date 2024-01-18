{ lib
, stdenv
, fetchFromGitHub
, ocamlPackages
, ncurses
, copyDesktopItems
, makeDesktopItem
, wrapGAppsHook
, gsettings-desktop-schemas
, zlib
, enableX11 ? true
, Cocoa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison";
  version = "2.53.2";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-H+70NZZP0cUsxetFcsjWEx2kENsgMdo/41wBwwaX6zg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocamlPackages.ocaml ]
    ++ lib.optionals enableX11 [ copyDesktopItems wrapGAppsHook ];
  buildInputs = [ ncurses zlib ]
    ++ lib.optionals enableX11 [ gsettings-desktop-schemas ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  preBuild = lib.optionalString enableX11 ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${ocamlPackages.lablgtk3}"/lib/ocaml/*/site-lib/lablgtk3)|" src/Makefile.OCaml
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${ocamlPackages.cairo2}"/lib/ocaml/*/site-lib/cairo2)|" src/Makefile.OCaml
  '' + ''
    echo -e '\ninstall:\n\tcp $(FSMONITOR)$(EXEC_EXT) $(INSTALLDIR)' >> src/fsmonitor/linux/Makefile
  '';

  makeFlags = [
    "INSTALLDIR=$(out)/bin/"
    "UISTYLE=${if enableX11 then "gtk3" else "text"}"
  ] ++ lib.optional (!ocamlPackages.ocaml.nativeCompilers) "NATIVE=false";

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = lib.optionalString enableX11 ''
    install -D $src/icons/U.svg $out/share/icons/hicolor/scalable/apps/unison.svg
  '';

  dontStrip = !ocamlPackages.ocaml.nativeCompilers;

  desktopItems = lib.optional enableX11 (makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "Unison";
    comment = "Bidirectional file synchronizer";
    genericName = "File synchronization tool";
    exec = "unison";
    icon = "unison";
    categories = [ "Utility" "FileTools" "GTK" ];
    startupNotify = true;
    startupWMClass = "Unison";
  });

  meta = with lib; {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
    mainProgram = "unison";
  };
})
