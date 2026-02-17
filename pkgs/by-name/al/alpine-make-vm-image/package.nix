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

stdenv.mkDerivation (finalAttrs: {
  pname = "alpine-make-vm-image";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "alpine-make-vm-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AIwT2JAGnMeMXUXZ0FRJthf22FvFfTTw/2LtZKPSj6g=";
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

  meta = {
    homepage = "https://github.com/alpinelinux/alpine-make-vm-image";
    description = "Make customized Alpine Linux disk image for virtual machines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
    mainProgram = "alpine-make-vm-image";
  };
})
