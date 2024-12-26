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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    rev = "v${version}";
    sha256 = "sha256-ilXoee19Wp/tB4f/0c7vWki+dnEPYp4f/IKzkGwxdbU=";
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
