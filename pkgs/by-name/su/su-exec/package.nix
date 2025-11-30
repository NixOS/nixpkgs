{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "su-exec";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ncopa";
    repo = "su-exec";
    rev = "v${version}";
    hash = "sha256-VUaparvPZhVOtAVPULIDQmpLUypl9aYYZlZrIIxuoTI=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -a su-exec $out/bin/su-exec
  '';

  meta = with lib; {
    description = "Switch user and group id and exec";
    mainProgram = "su-exec";
    homepage = "https://github.com/ncopa/su-exec";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.linux;
  };
}
