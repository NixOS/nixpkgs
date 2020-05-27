{ stdenv, buildGoModule, fetchurl
, go, ncurses, notmuch, scdoc
, python3, perl, w3m, dante
, fetchFromGitHub
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

  libvterm = fetchFromGitHub {
    owner = "ddevault";
    repo = "go-libvterm";
    rev = "b7d861da381071e5d3701e428528d1bfe276e78f";
    sha256 = "06vv4pgx0i6hjdjcar4ch18hp9g6q6687mbgkvs8ymmbacyhp7s6";
  };

  vendorSha256 = "0rnyjjlsxsi0y23m6ckyd52562m33qr35fvdcdzy31mbfpi8kl2k";

  overrideModAttrs = (_: {
      postBuild = ''
      cp -r --reflink=auto ${libvterm}/libvterm vendor/github.com/ddevault/go-libvterm
      cp -r --reflink=auto ${libvterm}/encoding vendor/github.com/ddevault/go-libvterm
      '';
    });

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
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}