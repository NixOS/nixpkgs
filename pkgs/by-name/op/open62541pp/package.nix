{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  # TODO Unpin dependency and remove open62541_1_4 when open62541pp is ported
  # to open62541 >= 1.5.0.
  # See https://github.com/open62541pp/open62541pp/issues/695
  open62541_1_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541pp";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "open62541pp";
    repo = "open62541pp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inweo5RGhNkUIRjQh43l5tRhfXoFRcRTHZFpETdIJgg=";
  };

  cmakeFlags = [
    (lib.cmakeBool "UAPP_INTERNAL_OPEN62541" false)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    open62541_1_4
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
