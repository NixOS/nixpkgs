{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "accesskit-c";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "AccessKit";
    repo = "accesskit-c";
    tag = finalAttrs.version;
    hash = "sha256-fIzGY8PkQV0Xen0kdBHHNEEczBdLRY9TL5aOY7oz4V4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-P0MRRhVg13cmPJFSK+WA05sT0Mpy9Kzyyr/vxFjZTX0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CORROSION" "${corrosion.src}")
  ];

  preConfigure = ''
    substituteInPlace accesskit.cmake \
      --replace-fail 'set(ACCESSKIT_INCLUDE_DIR' 'set(ACCESSKIT_INCLUDE_DIR "''${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "")  #' \
      --replace-fail 'set(ACCESSKIT_LIBRARIES_DIR' 'set(ACCESSKIT_LIBRARIES_DIR "''${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "")  #'
  '';

  postInstall = ''
    install -Dm644 $src/include/accesskit.h $out/include/accesskit.h
    mv $out/lib/static/* $out/lib/
    mv $out/lib/shared/* $out/lib/
    rmdir $out/lib/static $out/lib/shared
  '';

  meta = {
    description = "C bindings for the AccessKit accessibility toolkit";
    homepage = "https://github.com/AccessKit/accesskit-c";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ ndarilek ];
    platforms = lib.platforms.unix;
  };
})
