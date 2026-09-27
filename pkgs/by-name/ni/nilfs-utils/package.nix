{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libuuid,
  libselinux,
  e2fsprogs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nilfs-utils";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "nilfs-dev";
    repo = "nilfs-utils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sqg1pERzxc6H7eMJGv3XTgiC3/KXu/hqqZzl1vxM6E8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libuuid
    libselinux
  ];

  postPatch = ''
    substituteInPlace sbin/Makefile.am \
      --replace-fail '$(badblocksdir)' '${lib.getBin e2fsprogs}/bin'
  '';

  configureFlags = [
    "--with-libmount"
    "--enable-usrmerge=bin"
  ];

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  # FIXME: https://github.com/NixOS/patchelf/pull/98 is in, but stdenv
  # still doesn't use it
  #
  # To make sure patchelf doesn't mistakenly keep the reference via
  # build directory
  postInstall = ''
    find . -name .libs -exec rm -rf -- {} +
  '';

  outputs = [
    "out"
    "man"
    "dev"
  ];

  meta = {
    description = "NILFS utilities";
    homepage = "https://github.com/nilfs-dev/nilfs-utils";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl2Plus
      lgpl21
    ];
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
  };
})
