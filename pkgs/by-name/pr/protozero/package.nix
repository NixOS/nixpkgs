{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protozero";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kqR0YLxkRu8WclxaoR/zx+2sRTEZus7dUTbqjBkv12U=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with lib.licenses; [
      bsd2
      asl20
    ];
    changelog = [
      "https://github.com/mapbox/protozero/releases/tag/v${finalAttrs.version}"
      "https://github.com/mapbox/protozero/blob/v${finalAttrs.version}/CHANGELOG.md"
    ];
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ das-g ]);
  };
})
