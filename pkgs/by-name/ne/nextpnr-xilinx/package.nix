{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  nix-update-script,
  python312,
  python312Packages,
  eigen,
  llvmPackages,
}:

let
  prjxrayDb = fetchFromGitHub {
    owner = "openxc7";
    repo = "prjxray-db";
    rev = "381966a746cb4cf4a7f854f0e53caa3bf74fbe62";
    hash = "sha256-tQ1KfYj6kQq3fKBv6PAsqxm9btMNWFd5fT9UzOGMlkE=";
  };

  nextpnrXilinxMeta = fetchFromGitHub {
    owner = "openxc7";
    repo = "nextpnr-xilinx-meta";
    rev = "491aefcc15be159efc8ad8bff2a1a4b93fe487fe";
    hash = "sha256-oRVFPzdw9ctzT6iQ8YI3Q92LZTIlRPBZvJVjMqvDJQE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nextpnr-xilinx";
  version = "0.8.2-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "openXC7";
    repo = "nextpnr-xilinx";
    rev = "72d8217b80cafed22cbac1253a2f23ca1ee10806";
    hash = "sha256-YIwJfh6epUDGfWwHS0zjfcrx5A68NUY6gxyuEBb0g3A=";
  };

  nativeBuildInputs = [
    cmake
    gitMinimal
    python312
  ];

  buildInputs = [
    # Newer python fails with 'No version of Boost::Python 3.x could be found'
    python312Packages.boost
    python312
    eigen
  ]
  ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${lib.substring 0 7 finalAttrs.src.rev}"
    "-DARCH=xilinx"
    "-DBUILD_GUI=OFF"
    "-DBUILD_TESTS=OFF"
    "-DUSE_OPENMP=ON"
  ];

  postPatch = ''
    # Boost.System is header-only in modern Boost; requiring the component fails
    # with CMake's FindBoost in nixpkgs.
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(boost_libs filesystem thread program_options iostreams system)" \
                     "set(boost_libs filesystem thread program_options iostreams)"

    # GCC 15 requires explicit <cstdint> include for uint8_t in vendored json11.
    substituteInPlace 3rdparty/json11/json11.cpp \
      --replace-fail "#include <climits>" $'#include <climits>\n#include <cstdint>'

    rm -rf xilinx/external/prjxray-db xilinx/external/nextpnr-xilinx-meta
    ln -s ${prjxrayDb} xilinx/external/prjxray-db
    ln -s ${nextpnrXilinxMeta} xilinx/external/nextpnr-xilinx-meta
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp nextpnr-xilinx bbasm $out/bin/

    mkdir -p $out/share/nextpnr/external
    ln -s ${prjxrayDb} $out/share/nextpnr/external/prjxray-db
    cp -r ../xilinx/external/nextpnr-xilinx-meta $out/share/nextpnr/external/
    cp -r ../xilinx/python $out/share/nextpnr/
    cp ../xilinx/constids.inc $out/share/nextpnr/

    runHook postInstall
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Place and route tool for Xilinx 7-series FPGAs";
    homepage = "https://github.com/openXC7/nextpnr-xilinx";
    license = lib.licenses.isc;
    mainProgram = "nextpnr-xilinx";
    maintainers = with lib.maintainers; [ rcoeurjoly ];
    platforms = lib.platforms.unix;
  };
})
