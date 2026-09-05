{
  cmake,
  eve,
  fetchFromGitHub,
  fmt,
  lib,
  robin-map,
  spdlog,
  stdenv,
  tomlplusplus,
}:

let
  # ScalableVectorSearch requires a custom patched version of toml++.
  # https://github.com/intel/ScalableVectorSearch/blob/main/cmake/patches/tomlplusplus_v330.patch
  tomlplusplus' = (
    tomlplusplus.overrideAttrs (final: prev: { patches = prev.patches ++ [ ./tomlplusplus.patch ]; })
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "scalablevectorsearch";
  version = "0.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ScalableVectorSearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JoNUKOrFMDVz69/4WkEprL+EfTxcCF6sfwRk6Kf5x1E=";
  };

  patches = [ ./external-libs.patch ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    eve
    fmt
    robin-map
    spdlog
    tomlplusplus'
  ];

  meta = {
    changelog = "https://github.com/intel/ScalableVectorSearch/blob/${finalAttrs.src.tag}/NEWS.md";
    description = "Intel's Scalable Vector Search library";
    homepage = "https://github.com/intel/ScalableVectorSearch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hythera
      miniharinn
    ];
    platforms = lib.platforms.all;
  };
})
