{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "cbftp";
  version = "1173";

  src = fetchurl {
    url = "https://cbftp.eu/${pname}-r${version}.tar.gz";
    hash = "sha256-DE6fnLzWsx6Skz2LRJAaijjIqrYFB8/HPp45P5CcEc8=";
  };

  buildInputs = [
    ncurses
    openssl
  ];

  dontConfigure = true;

  makeFlags = lib.optional stdenv.hostPlatform.isDarwin "OPTFLAGS=-O0";

  installPhase = ''
    runHook preInstall

    install -D bin/* -t $out/bin/
    install -D API README -t $out/share/doc/${pname}/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://cbftp.eu/";
    description = "Advanced multi-purpose FTP/FXP client";
    longDescription = ''
      Cbftp is an advanced multi-purpose FTP/FXP client that focuses on
      efficient large-scale data spreading, while also supporting most regular
      FTP/FXP use cases in a modern way. It runs in a terminal and provides a
      semi-graphical user interface through ncurses.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
