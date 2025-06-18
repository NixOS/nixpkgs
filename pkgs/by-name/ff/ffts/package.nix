{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "ffts";
  version = "0-unstable-2019-03-19";

  src = fetchFromGitHub {
    owner = "linkotec";
    repo = "ffts";
    rev = "2c8da4877588e288ff4cd550f14bec2dc7bf668c";
    hash = "sha256-Cj0n7fwFAu6+3ojgczL0Unobdx/XzGNFvNVMXdyHXE4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DENABLE_SHARED=ON" ];

  meta = {
    description = "Fastest Fourier Transform in the South";
    homepage = "https://github.com/linkotec/ffts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bgamari ];
    platforms = lib.platforms.linux;
  };
}
