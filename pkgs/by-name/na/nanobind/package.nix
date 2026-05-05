{
  lib,
  stdenv,
  python3,
  cmake,
  ninja,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (python3.pkgs.nanobind)
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  propagatedBuildInputs = [
    python3
  ];
})
