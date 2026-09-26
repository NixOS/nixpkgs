{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "fparser";
  version = "0-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "fparser";
    rev = "ee15c675514e53b37304179b4a91319d44ba9a85";
    hash = "sha256-YlkaJlZ60EAsaejdyaV7OK3zF7pnkhyr+PssuToFplA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ Library for Evaluating Mathematical Functions";
    homepage = "https://github.com/thliebig/fparser";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
}
