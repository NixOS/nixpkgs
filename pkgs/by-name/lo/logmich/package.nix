{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  tinycmmc,
  fmt,
}:

stdenv.mkDerivation {
  pname = "logmich";
  version = "0.1.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "logmich";
    repo = "logmich";
    rev = "c73c7b7d6cd050d1bcc42d522ce80a2eb86da5c8";
    sha256 = "sha256-e8k/ZzPAfLgNF30wmXHDX5ovK/msTH6sgzxWKzZhtOY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ tinycmmc ];
  propagatedBuildInputs = [ fmt ];

  meta = {
    description = "A trivial logging library";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
  };
}
