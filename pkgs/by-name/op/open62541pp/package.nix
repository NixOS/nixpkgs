{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  open62541,
}:

let
  # open62541pp is currently incompatible with open62541 >= 1.5.0.
  # Remove the workaround when open62541pp has been ported.
  # https://github.com/open62541pp/open62541pp/issues/695
  use-vendored-open62541 = lib.versionAtLeast open62541.version "1.5.0";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541pp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "open62541pp";
    repo = "open62541pp";
    tag = "v${finalAttrs.version}";
    hash =
      if use-vendored-open62541 then
        "sha256-0IRmEyW/q0GEmACc/XNcr25nx1DfOhjbeQ+dhZC+GQU="
      else
        "sha256-4l5cqugKCi7yeZqY5+gHBk1OLur3JbgaK2cWVLUq8/k=";
    fetchSubmodules = use-vendored-open62541;
  };

  cmakeFlags = [
    (lib.cmakeBool "UAPP_INTERNAL_OPEN62541" use-vendored-open62541)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = if use-vendored-open62541 then open62541.buildInputs else [ open62541 ];

  meta = {
    description = "C++ wrapper of the open62541 OPC UA library";
    homepage = "https://open62541pp.github.io/open62541pp";
    changelog = "https://github.com/open62541pp/open62541pp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
