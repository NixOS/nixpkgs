{lib, stdenv, fetchFromGitHub, ocamlPackages, fontschumachermisc, xset, makeWrapper, ncurses, gnugrep, fetchpatch
, enableX11 ? true}:

let inherit (ocamlPackages) ocaml lablgtk; in

stdenv.mkDerivation (rec {

  pname = "unison";
  version = "2.51.3";
  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${version}";
    sha256 = "sha256-42hmdMwOYSWGiDCmhuqtpCWtvtyD2l+kA/bhHD/Qh5Y=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml ncurses ];

  patches = [
    # Patch to fix build with ocaml 4.12. Remove in 2.51.4
    # https://github.com/bcpierce00/unison/pull/481
    (fetchpatch {
      name = "fix-compile-with-ocaml-4.12.patch";
      url = "https://github.com/bcpierce00/unison/commit/14b885316e0a4b41cb80fe3daef7950f88be5c8f.patch?full_index=1";
      sha256 = "0j1rma1cwdsfql19zvzhfj2ys5c4lbhjcp6jrnck04xnckxxiy3d";
    })
  ];

  preBuild = (if enableX11 then ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)|" src/Makefile.OCaml
  '' else "") + ''
  echo -e '\ninstall:\n\tcp $(FSMONITOR)$(EXEC_EXT) $(INSTALLDIR)' >> src/fsmonitor/linux/Makefile
  '';

  makeFlags = [
    "INSTALLDIR=$(out)/bin/"
    "UISTYLE=${if enableX11 then "gtk2" else "text"}"
  ] ++ lib.optional (!ocaml.nativeCompilers) "NATIVE=false";

  preInstall = "mkdir -p $out/bin";

  postInstall = if enableX11 then ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | ${gnugrep}/bin/grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done
  '' else "";

  dontStrip = !ocaml.nativeCompilers;

  meta = {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; unix;
  };

})
