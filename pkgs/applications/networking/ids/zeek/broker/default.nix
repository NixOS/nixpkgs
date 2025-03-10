{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  prometheus-cpp,
  python3,
  caf,
  openssl,
}:
let
  inherit (stdenv.hostPlatform) isStatic;

  src-cmake = fetchFromGitHub {
    owner = "zeek";
    repo = "cmake";
    rev = "85c6f90f238b5851edbd6b6962f44de34833a76c";
    hash = "sha256-oaTzJnKw4kT9oJl6YKb+WjI2pUfuxnyl/ZZ4PFwa5rA=";
  };
  src-3rdparty = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek-3rdparty";
    rev = "a6cc3c7603bb535cf3bec7442140e7126e0577a8";
    hash = "sha256-yzhuTam9zOQ3MP7fk+ACN5P5tHtHXWbyQP73DwISIv8=";
  };
  caf' = caf.overrideAttrs (old: {
    version = "unstable-2024-09-14-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "10afbbc5ee40263b258b7cf3f0e5abb436f79e89";
      hash = "sha256-R22eKAFNP2VVA4eL6ycN6aHM0NgDHVll9aFNmOQ/pDc=";
    };
    cmakeFlags = old.cmakeFlags ++ [
      "-DCAF_ENABLE_TESTING=OFF"
    ];
    doCheck = false;
  });
in
stdenv.mkDerivation {
  pname = "zeek-broker";
  version = "2.6.0-unstable-2024-12-13";
  outputs = [
    "out"
    "py"
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "5847b2a5458d03d56654e19b6b51a182476d36e5";
    hash = "sha256-JLnzzhuOlBDNfhiULZFe1MRPIvX22bXx5EoSIf9JZ+0=";
  };
  postUnpack = ''
    rmdir $sourceRoot/cmake $sourceRoot/3rdparty
    ln -s ${src-cmake} ''${sourceRoot}/cmake
    ln -s ${src-3rdparty} ''${sourceRoot}/3rdparty

    # Refuses to build the bindings unless this file is present, but never
    # actually uses it.
    touch $sourceRoot/bindings/python/3rdparty/pybind11/CMakeLists.txt
  '';

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace bindings/python/CMakeLists.txt --replace " -u -r" ""
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    openssl
    prometheus-cpp
    python3.pkgs.pybind11
  ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
    "-Dprometheus-cpp_ROOT=${lib.getDev prometheus-cpp}"
  ];

  meta = with lib; {
    description = "Zeek's Messaging Library";
    mainProgram = "broker-benchmark";
    homepage = "https://github.com/zeek/broker";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
