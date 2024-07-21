{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "geoarrow-c";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-c";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-uEB+D3HhrjnCgExhguZkmvYzULWo5gAWxXeIGQOssqo=";
  };

  nativeBuildInputs = [ cmake ];
  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "https://geoarrow.org/geoarrow-c";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
