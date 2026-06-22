{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ggml";
  version = "0.15.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "ggml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T0MHPtyTjt2rUZlU9fHtx0p/3BaKPDPH58nXb1cjfBk=";
  };

  # The cmake package does not handle absolute CMAKE_INSTALL_LIBDIR and CMAKE_INSTALL_INCLUDEDIR
  # correctly.
  # Tracking: https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace ggml.pc.in \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" \
        "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" \
        "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Tensor library for machine learning";
    homepage = "https://github.com/ggml-org/ggml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
