{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation {
  # Same version as in VCPKG as of February 2025.
  # https://github.com/microsoft/vcpkg/blob/master/ports/azure-macro-utils-c/portfile.cmake
  pname = "azure-macro-utils-c";
  version = "1.1.0-unstable-2022-01-21";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "macro-utils-c";
    rev = "5926caf4e42e98e730e6d03395788205649a3ada";
    hash = "sha256-K5G+g+Jnzf7qfb/4+rVOpVgSosoEtNV3Joct1y1Xcdw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = {
    homepage = "https://github.com/Azure/macro-utils-c";
    description = "C header file that contains a multitude of very useful C macros";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = lib.platforms.all;
  };
}
