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
    version = "unstable-2022-11-17-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "4f580d89f35ae4d475505101623c8b022c0c6aa6";
      hash = "sha256-8KGXg072lZiq/rC5ZuThDGRjeYvVVFBd3ea8yhUHOYY=";
    };
    cmakeFlags = old.cmakeFlags ++ [
      "-DCAF_ENABLE_TESTING=OFF"
    ];
    doCheck = false;
  });
in
stdenv.mkDerivation rec {
  pname = "zeek-broker";
  version = "2.7.0";
  outputs = [ "out" "py" ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "v${version}";
    hash = "sha256-fwLqw7PPYUDm+eJxDpCtY/W6XianqBDPHOhzDQoooYo=";
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

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace bindings/python/CMakeLists.txt --replace " -u -r" ""
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl python3.pkgs.pybind11 ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-faligned-allocation";

  meta = with lib; {
    description = "Zeek's Messaging Library";
    homepage = "https://github.com/zeek/broker";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
