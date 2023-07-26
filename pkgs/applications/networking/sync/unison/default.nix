{ lib
, stdenv
, fetchFromGitHub
, ocamlPackages
, ncurses
, copyDesktopItems
, makeDesktopItem
, wrapGAppsHook
, glib
, gsettings-desktop-schemas
, zlib
, enableX11 ? true
, Cocoa
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison";
  version = "2.53.3";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XKQKNc0YpYrtXGmbDBMkIqelegrcgGhQQYBb78PsMBY=";
  };

  strictDeps = true;

  nativeBuildInputs = [ glib wrapGAppsHook ocamlPackages.ocaml ]
    ++ lib.optional enableX11 copyDesktopItems;
  buildInputs = [ gsettings-desktop-schemas ncurses zlib ]
    ++ lib.optional stdenv.isDarwin Cocoa;

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

  installPhase = ''
    install -D src/unison $out/bin/unison

    if [ -f "src/unison-gui" ]; then
       install -D src/unison-gui $out/bin/unison-gui
    fi

    if [ -f "src/unison-fsmonitor" ]; then
       install -D src/unison-fsmonitor $out/bin/unison-fsmonitor
    else
      install -D src/fsmonitor.py $out/bin/fsmonitor.py
    fi
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
})
