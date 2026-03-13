{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  fuse,
  libmtp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "simple-mtpfs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "phatina";
    repo = "simple-mtpfs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vAqi2owa4LJK7y7S7TwkPAqDxzyHrZZBTu0MBwMT0gI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];
  buildInputs = [
    fuse
    libmtp
  ];

  meta = {
    description = "Simple MTP fuse filesystem driver";
    homepage = "https://github.com/phatina/simple-mtpfs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ laalsaas ];
    mainProgram = "simple-mtpfs";
  };
})
