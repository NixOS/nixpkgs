{ lib, stdenv, fetchFromGitHub, fetchpatch, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fTtNDjswxHv2kHU55RCzz9tdlXw+RUCSoe3qF4hQ7u4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-27781.patch";
      url = "https://github.com/tjko/jpegoptim/commit/29a073ad297a0954f5e865264e24755d0ffe53ed.patch";
      hash = "sha256-YUjVg0cvElhzMG3b4t5bqcqnHAuzDoNvSqe0yvlgX4E=";
    })
  ];

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = with lib; {
    description = "Optimize JPEG files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
  };
}
