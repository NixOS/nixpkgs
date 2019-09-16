{ stdenv, buildGoModule, fetchurl
, go, ncurses, scdoc
, python3, perl, w3m, dante
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.2.1";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/aerc/archive/${version}.tar.gz";
    sha256 = "1ky1nl5b54lf5jnac2kb5404fplwnwypjplas8imdlsf517fw32n";
  };

  nativeBuildInputs = [
    go
    scdoc
    python3.pkgs.wrapPython
  ];

  pythonPath = [
    python3.pkgs.colorama
  ];

  buildInputs = [ python3 perl ];

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
      "$out/share/aerc/filters:${stdenv.lib.makeBinPath [ ncurses.dev ]}"
    wrapProgram $out/share/aerc/filters/html --prefix PATH ":" \
      ${stdenv.lib.makeBinPath [ w3m dante ]}
  '';

  modSha256 = "0fc9m1qb8innypc8cxzbqyrfkawawyaqq3gqy7lqwmyh32f300jh";

  meta = with stdenv.lib; {
    description = "aerc is an email client for your terminal";
    homepage = https://aerc-mail.org/;
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
