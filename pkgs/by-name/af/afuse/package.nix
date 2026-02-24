{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "afuse";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pcarrier";
    repo = "afuse";
    tag = "v${version}";
    sha256 = "sha256-KpysJRvDx+12BSl9pIGRqbJAM4W1NbzxMgDycGCr2RM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fuse ];

  patches = [ ./001-darwin-fdatasync.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix the build on macOS with macFUSE installed
    substituteInPlace configure.ac --replace-fail \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' \
      ""
  '';

  meta = {
    description = "Automounter in userspace";
    homepage = "https://github.com/pcarrier/afuse";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
