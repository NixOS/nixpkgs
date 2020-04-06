{ stdenv, buildGoModule, fetchurl
, go, ncurses, notmuch, scdoc
, python3, perl, w3m, dante
}:

let
  rev = "ea0df7bee433fedae5716906ea56141f92b9ce53";
in buildGoModule rec {
  pname = "aerc";
  version = "unstable-2020-02-01";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/aerc/archive/${rev}.tar.gz";
    sha256 = "1bx2fypw053v3bzalfgyi6a0s5fvv040z8jy4i63s7p53m8gmzs9";
  };

  modSha256 = "127xrah6xxrvc224g5dxn432sagrssx8v7phzapcsdajsnmagq6x";

  nativeBuildInputs = [
    scdoc
    python3.pkgs.wrapPython
  ];

  patches = [
    ./runtime-sharedir.patch
  ];

  pythonPath = [
    python3.pkgs.colorama
  ];

  buildInputs = [ python3 notmuch ];

  GOFLAGS="-tags=notmuch";

  buildPhase = "
    runHook preBuild
    # we use make instead of go build
    runHook postBuild
  ";

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
    wrapPythonProgramsIn $out/share/aerc/filters "$out $pythonPath"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/aerc --prefix PATH ":" \
      "$out/share/aerc/filters:${stdenv.lib.makeBinPath [ ncurses ]}"
    wrapProgram $out/share/aerc/filters/html --prefix PATH ":" \
      ${stdenv.lib.makeBinPath [ w3m dante ]}
  '';

  meta = with stdenv.lib; {
    description = "aerc is an email client for your terminal";
    homepage = https://aerc-mail.org/;
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
