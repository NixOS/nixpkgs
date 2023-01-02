{ lib
, pkgs
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
}:

mkDerivation rec {
  pname = "cask-server";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/dDrJcyp6+r6G3E0KPOEH0hEY9C5XIg1z2gRZV3GZcg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Public server and API to interface with Cask features";
    homepage = "https://github.com/Nitrux/cask-server";
    license = with licenses; [
      bsd2
      lgpl21Plus
      cc0
    ];
    maintainers = with maintainers; [ onny ];
  };

}
