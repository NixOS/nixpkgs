{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  open62541,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541pp";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "open62541pp";
    repo = "open62541pp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xFiL+biDETGNwWzbTcfAi3GF1Dj9vvXEj2wJ+GoFz1Q=";
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
    changelog = "https://github.com/open62541pp/open62541pp/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
