{ lib, buildGoModule, fetchFromSourcehut
, ncurses, notmuch, scdoc
, python3, w3m, dante
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = pname;
    rev = version;
    sha256 = "sha256-wiylBBqnivDnMUyCg3Zateu4jcjicTfrQFALT8dg5No=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-hpGd78PWk3tIwB+TPmPy0gKkU8+t5NTm9RzPuLae+Fk=";

  doCheck = false;

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
      "$out/share/aerc/filters:${lib.makeBinPath [ ncurses ]}"
    wrapProgram $out/share/aerc/filters/html --prefix PATH ":" \
      ${lib.makeBinPath [ w3m dante ]}
  '';

  meta = with lib; {
    description = "An email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
