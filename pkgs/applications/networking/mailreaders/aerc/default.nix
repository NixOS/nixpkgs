{ stdenv, buildGoModule, fetchurl
, go, scdoc
, python3, perl, w3m, dante
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.1.4";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/aerc/archive/${version}.tar.gz";
    sha256 = "0vlqgcjbq6yp7ffrfs3zwa9hrm4vyx9245v9pkqdn328xlff3h55";
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

  modSha256 = "0v1b76nax5295bjrq19wdzm2ixiszlk7j1v1k9sjz4la07h5bvfj";

  meta = with stdenv.lib; {
    description = "aerc is an email client for your terminal";
    homepage = https://aerc-mail.org/;
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
