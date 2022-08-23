{ lib
, stdenv
, fetchFromGitHub
, ocamlPackages
, fontschumachermisc
, xset
, makeWrapper
, ncurses
, gnugrep
, copyDesktopItems
, makeDesktopItem
, enableX11 ? true
}:

stdenv.mkDerivation rec {
  pname = "unison";
  version = "2.52.1";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${version}";
    sha256 = "sha256-taA8eZ/wOe9uMccXVYfe34/XzWgqYKA3tLZnIOahOrQ=";
  };

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional enableX11 copyDesktopItems;
  buildInputs = [ ocamlPackages.ocaml ncurses ];

  preBuild = lib.optionalString enableX11 ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${ocamlPackages.lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)|" src/Makefile.OCaml
  '' + ''
    echo -e '\ninstall:\n\tcp $(FSMONITOR)$(EXEC_EXT) $(INSTALLDIR)' >> src/fsmonitor/linux/Makefile
  '';

  makeFlags = [
    "INSTALLDIR=$(out)/bin/"
    "UISTYLE=${if enableX11 then "gtk2" else "text"}"
  ] ++ lib.optional (!ocamlPackages.ocaml.nativeCompilers) "NATIVE=false";

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = lib.optionalString enableX11 ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | ${gnugrep}/bin/grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done

    install -D $src/icons/U.svg $out/share/icons/hicolor/scalable/apps/unison.svg
  '';

  dontStrip = !ocamlPackages.ocaml.nativeCompilers;

  desktopItems = lib.optional enableX11 (makeDesktopItem {
    name = pname;
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
  };
}
