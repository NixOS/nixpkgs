{ stdenv, lib, fetchFromGitHub, makeWrapper, docker, coreutils, procps, gnused, findutils, gnugrep }:

with lib;

stdenv.mkDerivation rec {
  name = "docker-gc-${rev}";
  rev = "b0cc52aa3da2e2ac0080794e0be6e674b1f063fc";

  src = fetchFromGitHub {
    inherit rev;
    owner = "spotify";
    repo = "docker-gc";
    sha256 = "07wf9yn0f771xkm3x12946x5rp83hxjkd70xgfgy35zvj27wskzm";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp docker-gc $out/bin
    chmod +x $out/bin/docker-gc
    wrapProgram $out/bin/docker-gc \
        --prefix PATH : "${stdenv.lib.makeBinPath [ docker coreutils procps gnused findutils gnugrep ]}"
  '';

  meta = {
    description = "Docker garbage collection of containers and images";
    license = licenses.asl20;
    homepage = https://github.com/spotify/docker-gc;
    maintainers = with maintainers; [offline];
    platforms = docker.meta.platforms;
  };
}
