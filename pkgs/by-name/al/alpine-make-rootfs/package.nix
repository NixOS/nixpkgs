{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  apk-tools,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  rsync,
  util-linux,
  wget,
}:
stdenvNoCC.mkDerivation rec {
  pname = "alpine-make-rootfs";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-rootfs";
    tag = "v${version}";
    hash = "sha256-sNqaMBtbklSBcKxsc3ROI30bE1PUzJJeZqLqC9p3H+U=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-rootfs --set PATH ${
      lib.makeBinPath [
        apk-tools
        coreutils
        findutils
        gnugrep
        gnused
        gnutar
        gzip
        rsync
        util-linux
        wget
      ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/alpinelinux/alpine-make-rootfs";
    description = "Make customized Alpine Linux rootfs (base image) for containers";
    mainProgram = "alpine-make-rootfs";
    maintainers = with maintainers; [ danielsidhion ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
