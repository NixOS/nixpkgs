{ stdenv
, lib
, fetchFromGitHub
, cmake
, python3
, caf
, openssl
}:
let
  inherit (stdenv.hostPlatform) isStatic;

  src-cmake = fetchFromGitHub {
    owner = "zeek";
    repo = "cmake";
    rev = "1be78cc8a889d95db047f473a0f48e0baee49f33";
    hash = "sha256-zcXWP8CHx0RSDGpRTrYD99lHlqSbvaliXrtFowPfhBk=";
  };
  src-3rdparty = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek-3rdparty";
    rev = "eb87829547270eab13c223e6de58b25bc9a0282e";
    hash = "sha256-AVaKcRjF5ZiSR8aPSLBzSTeWVwGWW/aSyQJcN0Yhza0=";
  };
  caf' = caf.overrideAttrs (old: {
    version = "unstable-2024-01-07-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "e3048cdd13e085c97870a55eb1f9de04e25320f3";
      hash = "sha256-uisoYXiZbFQa/TfWGRrCJ23MX4bg8Ds86ffC8sZSRNQ=";
    };
    cmakeFlags = old.cmakeFlags ++ [
      "-DCAF_ENABLE_TESTING=OFF"
    ];
    doCheck = false;
  });
in
stdenv.mkDerivation rec {
  pname = "zeek-broker";
  version = "6.2.0";
  outputs = [ "out" "py" ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "v${version}";
    hash = "sha256-SG5TzozKvYc7qcEPJgiEtsxgzdZbbJt90lmuUbCPyv0=";
  };
  postUnpack = ''
    rmdir $sourceRoot/cmake $sourceRoot/3rdparty
    ln -s ${src-cmake} ''${sourceRoot}/cmake
    ln -s ${src-3rdparty} ''${sourceRoot}/3rdparty

    # Refuses to build the bindings unless this file is present, but never
    # actually uses it.
    touch $sourceRoot/bindings/python/3rdparty/pybind11/CMakeLists.txt
  '';

  patches = [
    ./0001-Fix-include-path-in-exported-CMake-targets.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace bindings/python/CMakeLists.txt --replace " -u -r" ""
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ openssl python3.pkgs.pybind11 ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-faligned-allocation";

  meta = with lib; {
    description = "Zeek's Messaging Library";
    mainProgram = "broker-benchmark";
    homepage = "https://github.com/zeek/broker";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
