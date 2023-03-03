{ stdenv
, lib
, callPackage
, fetchFromGitHub
, cmake
, pkg-config
, python3
, caf
, openssl
}:
let
  inherit (stdenv.hostPlatform) isStatic;

  src-cmake = fetchFromGitHub {
    owner = "zeek";
    repo = "cmake";
    rev = "0b7a543554622600bc0a42b57a22f291a4fbd86c";
    hash = "sha256-kaBOBTpfR3XyuF4PW5NQKca/UhXXxJJcXVsErFU1VYY=";
  };
  src-3rdparty = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek-3rdparty";
    rev = "eb87829547270eab13c223e6de58b25bc9a0282e";
    hash = "sha256-AVaKcRjF5ZiSR8aPSLBzSTeWVwGWW/aSyQJcN0Yhza0=";
  };
  caf' = caf.overrideAttrs (old: {
    version = "unstable-2022-11-17-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "dbb68b4573736d7aeb69268cc73aa766c998b3dd";
      hash = "sha256-RV2mKF3B47h/hDgK/D1UJN/ll2G5rcPkHaLVY1/C/Pg=";
    };
    checkPhase = ''
      runHook preCheck
      libcaf_core/caf-core-test
      libcaf_io/caf-io-test
      libcaf_openssl/caf-openssl-test
      libcaf_net/caf-net-test --not-suites='net.*'
      runHook postCheck
    '';
  });
in
stdenv.mkDerivation rec {
  pname = "zeek-broker";
  version = "2.4.2";
  outputs = [ "out" "py" ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "v${version}";
    hash = "sha256-y07fJEVPDGPv5VThE45SwM342VS6LnEtMvazZHadM/k=";
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

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl python3.pkgs.pybind11 ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
  ];

  meta = with lib; {
    description = "Zeek's Messaging Library";
    homepage = "https://github.com/zeek/broker";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
