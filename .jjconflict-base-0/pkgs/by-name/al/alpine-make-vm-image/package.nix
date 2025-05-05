{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  apk-tools,
  coreutils,
  dosfstools,
  e2fsprogs,
  findutils,
  gnugrep,
  gnused,
  kmod,
  qemu-utils,
  rsync,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "alpine-make-vm-image";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    hash = "sha256-N7S9MlTpLIL5Od+buS7q64v8fmN+wbYK1FH/YW+nMP8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/alpine-make-vm-image --set PATH ${
      lib.makeBinPath [
        apk-tools
        coreutils
        dosfstools
        e2fsprogs
        findutils
        gnugrep
        gnused
        kmod
        qemu-utils
        rsync
        util-linux
      ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/alpinelinux/alpine-make-vm-image";
    description = "Make customized Alpine Linux disk image for virtual machines";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
    mainProgram = "alpine-make-vm-image";
  };
}
