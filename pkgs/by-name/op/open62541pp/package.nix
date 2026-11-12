{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  open62541,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541pp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "open62541pp";
    repo = "open62541pp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4l5cqugKCi7yeZqY5+gHBk1OLur3JbgaK2cWVLUq8/k=";
  };

  cmakeFlags = [
    (lib.cmakeBool "UAPP_INTERNAL_OPEN62541" false)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    open62541
  ];

  meta = {
    description = "C++ wrapper of the open62541 OPC UA library";
    homepage = "https://open62541pp.github.io/open62541pp";
    changelog = "https://github.com/open62541pp/open62541pp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
