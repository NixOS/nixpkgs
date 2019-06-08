{ stdenv, buildGoModule, fetchurl
, go, scdoc
, python3, perl, w3m, dante
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.1.0";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/aerc/archive/${version}.tar.gz";
    sha256 = "0wx9l097s51ih4khk231f9fs3vw55an8l2jx3q13v7y20522wgnk";
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
    wrapProgram $out/bin/aerc --prefix PATH ":" "$out/share/aerc/filters"
    wrapProgram $out/share/aerc/filters/html --prefix PATH ":" \
      ${stdenv.lib.makeBinPath [ w3m dante ]}
  '';

  modSha256 = "1h0vr01s2y0k3jjigz0h8ngjv1mhk6kw8mdisp5pr017jbhijfsi";

  meta = with stdenv.lib; {
    description = "aerc is an email client for your terminal";
    homepage = https://aerc-mail.org/;
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
