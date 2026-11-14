{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  docker,
  coreutils,
  procps,
  gnused,
  findutils,
  gnugrep,
}:
stdenv.mkDerivation {
  pname = "docker-gc";
  version = "0.1.0-unstable-2015-10-05";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "docker-gc";
    rev = "b0cc52aa3da2e2ac0080794e0be6e674b1f063fc";
    hash = "sha256-9U/Nj5D7l+Gfex2cNmWHA91cuiFJhD7q7OEcB6xPjh8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp docker-gc $out/bin
    chmod +x $out/bin/docker-gc
    wrapProgram $out/bin/docker-gc \
        --prefix PATH : "${
          lib.makeBinPath [
            docker
            coreutils
            procps
            gnused
            findutils
            gnugrep
          ]
        }"
  '';

  meta = {
    description = "Docker garbage collection of containers and images";
    mainProgram = "docker-gc";
    license = lib.licenses.asl20;
    homepage = "https://github.com/spotify/docker-gc";
    maintainers = [ ];
    platforms = docker.meta.platforms;
  };
}
