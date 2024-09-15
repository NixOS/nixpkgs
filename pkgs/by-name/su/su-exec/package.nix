{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "su-exec";
  version = "0.2";

  src = fetchFromGitHub {
    owner  = "ncopa";
    repo   = "su-exec";
    rev    = "v${version}";
    hash = "sha256-eymE9r9Rm/u4El5wXHbkAh7ma5goWV0EdJIhsq+leIs=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -a su-exec $out/bin/su-exec
  '';

  meta = with lib; {
    description = "switch user and group id and exec";
    mainProgram = "su-exec";
    homepage    = "https://github.com/ncopa/su-exec";
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms   = platforms.linux;
  };
}
