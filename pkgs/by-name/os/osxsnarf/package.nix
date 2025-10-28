{
  stdenv,
  lib,
  fetchFromGitHub,
  plan9port,
}:

stdenv.mkDerivation rec {
  pname = "osxsnarf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "osxsnarf";
    rev = "v${version}";
    sha256 = "1vpg39mpc5avnv1j0yfx0x2ncvv38slmm83zv6nmm7alfwfjr2ss";
  };

  buildInputs = [
    plan9port
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "Plan 9-inspired way to share your OS X clipboard";
    homepage = "https://github.com/eraserhd/osxsnarf";
    license = licenses.unlicense;
    platforms = platforms.darwin;
    maintainers = [ maintainers.eraserhd ];
  };
}
