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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-rootfs";
    rev = "v${version}";
    hash = "sha256-B5qYQ6ah4hFZfb3S5vwgevh7aEHI3YGLoA+IyipaDck=";
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
