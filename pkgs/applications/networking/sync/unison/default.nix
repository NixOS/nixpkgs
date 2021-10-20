{ lib
, stdenv
, fetchFromGitHub
, ocamlPackages
, fontschumachermisc
, xset
, makeWrapper
, ncurses
, gnugrep
, fetchpatch
, copyDesktopItems
, makeDesktopItem
, enableX11 ? true
}:

stdenv.mkDerivation rec {
  pname = "unison";
  version = "2.51.3";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${version}";
    sha256 = "sha256-42hmdMwOYSWGiDCmhuqtpCWtvtyD2l+kA/bhHD/Qh5Y=";
  };

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional enableX11 copyDesktopItems;
  buildInputs = [ ocamlPackages.ocaml ncurses ];

  patches = [
    # Patch to fix build with ocaml 4.12. Remove in 2.51.4
    # https://github.com/bcpierce00/unison/pull/481
    (fetchpatch {
      name = "fix-compile-with-ocaml-4.12.patch";
      url = "https://github.com/bcpierce00/unison/commit/14b885316e0a4b41cb80fe3daef7950f88be5c8f.patch?full_index=1";
      sha256 = "0j1rma1cwdsfql19zvzhfj2ys5c4lbhjcp6jrnck04xnckxxiy3d";
    })
  ];

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
    categories = "Utility;FileTools;GTK;";
    extraDesktopEntries = {
      StartupWMClass = "Unison";
      StartupNotify = "true";
      X-MultipleArgs = "false";
    };
  });

  meta = with lib; {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}
