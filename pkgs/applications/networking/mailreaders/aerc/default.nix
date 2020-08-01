{ stdenv, buildGoModule, fetchurl
, go, ncurses, notmuch, scdoc
, python3, perl, w3m, dante
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.4.0";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/aerc/archive/${version}.tar.gz";
    sha256 = "05qy14k9wmyhsg1hiv4njfx1zn1m9lz4d1p50kc36v7pq0n4csfk";
  };

  runVend = true;
  vendorSha256 = "0avdvbhv1jlisiicpi5vshz28a2p2fgnlrag9zngzglcrbhdd1rn";

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

  buildPhase = "
    runHook preBuild
    # we use make instead of go build
    runHook postBuild
  ";

  installPhase = ''
    runHook preInstall
    make PREFIX=$out GOFLAGS="$GOFLAGS -tags=notmuch" install
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
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
