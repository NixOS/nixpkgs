{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:

stdenv.mkDerivation rec {
  version = "1.43";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "sha256-kj6OLuK88KFZKJ7cV6bJNsB67WvB3lS5BRPJZvH+aIQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "mxt-app";
  };
}
