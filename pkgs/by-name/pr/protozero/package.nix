{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "protozero";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "sha256-kqR0YLxkRu8WclxaoR/zx+2sRTEZus7dUTbqjBkv12U=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [
      bsd2
      asl20
    ];
    changelog = [
      "https://github.com/mapbox/protozero/releases/tag/v${version}"
      "https://github.com/mapbox/protozero/blob/v${version}/CHANGELOG.md"
    ];
    maintainers = with maintainers; teams.geospatial.members ++ [ das-g ];
  };
}
