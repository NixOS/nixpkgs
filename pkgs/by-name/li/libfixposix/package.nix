{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  getconf,
}:

stdenv.mkDerivation rec {
  pname = "libfixposix";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "sionescu";
    repo = "libfixposix";
    rev = "v${version}";
    sha256 = "sha256-5qA6ytbqE+/05XQGxP9/4vEs9gFcuI3k7eJJYucW7fM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ getconf ];

  meta = with lib; {
    homepage = "https://github.com/sionescu/libfixposix";
    description = "Thin wrapper over POSIX syscalls and some replacement functionality";
    license = licenses.boost;
    maintainers = with maintainers; [
      orivej
      raskin
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
