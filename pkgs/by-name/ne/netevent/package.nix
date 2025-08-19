{
  lib,
  stdenv,
  fetchFromGitHub,
  docutils,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "netevent";
  version = "20230429";

  src = fetchFromGitHub {
    owner = "Blub";
    repo = "netevent";
    rev = "bcadfcc42db0f57a28abddbf19d382453cb1c81f";
    sha256 = "ikC6S1LNkmv474dlhajtEuHat497Rcdo9O+bCQMXTHQ=";
  };

  buildInputs = [ docutils ];
  nativeBuildInputs = [ installShellFiles ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  configurePhase = ''
    runHook preConfigure

    export RST2MAN=rst2man
    ./configure

    runHook postConfigure
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 netevent $out/bin/

    installManPage doc/netevent.1

    mkdir -p $doc/share/doc/netevent
    cp doc/netevent.rst $doc/share/doc/netevent/netevent.rst
  '';

  meta = with lib; {
    description = "Share linux event devices with other machines";
    homepage = "https://github.com/Blub/netevent";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
