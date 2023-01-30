{ lib
, stdenv
, fetchFromGitHub
, cmake
, arrayfire
, glog
}:

stdenv.mkDerivation rec {
  pname = "wav2letter";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "flashlight";
    repo = "wav2letter";
    # this breaks because of a bug in fetchurl https://github.com/NixOS/nixpkgs/issues/213560
    #rev = "v${version}";
    rev = "b1d1f89f586120a978a4666cffd45c55f0a2e564";
    sha256 = "sha256-0WH6um0w4uz3lMyvMuS1v2g7hUGcsXq2fbfB6oDlFbQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    arrayfire
    glog
  ];

  meta = {
    homepage = "https://github.com/flashlight/wav2letter";
    description = "Facebook AI Research's Automatic Speech Recognition Toolkit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
