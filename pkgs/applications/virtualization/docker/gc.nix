{ stdenv, lib, fetchFromGitHub, makeWrapper, docker, coreutils, procps, gnused, findutils, gnugrep }:

with lib;

stdenv.mkDerivation rec {
  pname = "docker-gc";
  version = "unstable-2015-10-5";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "docker-gc";
    rev = "b0cc52aa3da2e2ac0080794e0be6e674b1f063fc";
    sha256 = "07wf9yn0f771xkm3x12946x5rp83hxjkd70xgfgy35zvj27wskzm";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp docker-gc $out/bin
    chmod +x $out/bin/docker-gc
    wrapProgram $out/bin/docker-gc \
        --prefix PATH : "${lib.makeBinPath [ docker coreutils procps gnused findutils gnugrep ]}"
  '';

  meta = {
    description = "Docker garbage collection of containers and images";
    mainProgram = "docker-gc";
    license = licenses.asl20;
    homepage = "https://github.com/spotify/docker-gc";
    maintainers = with maintainers; [offline];
    platforms = docker.meta.platforms;
  };
}
