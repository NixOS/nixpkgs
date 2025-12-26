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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-rootfs";
    tag = "v${version}";
    hash = "sha256-ktGJXPJK94RbdqcgsA3fA8+MO0inaRcwaDLx18KFo1w=";
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

  meta = {
    homepage = "https://github.com/alpinelinux/alpine-make-rootfs";
    description = "Make customized Alpine Linux rootfs (base image) for containers";
    mainProgram = "alpine-make-rootfs";
    maintainers = with lib.maintainers; [ danielsidhion ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
