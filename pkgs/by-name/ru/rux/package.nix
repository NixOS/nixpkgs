{
  lib,
  llvmPackages_21,
  fetchFromGitHub,
  cmake,
  ninja,
}:

llvmPackages_21.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "rux";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rux-lang";
    repo = "Rux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GqShkT8uXi0C1W0G2+nuU8p1NcigdfEPOF/Yb5KCOhk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 4.2)" "cmake_minimum_required(VERSION 4.1)"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    llvmPackages_21.libcxx
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_SCAN_FOR_MODULES=OFF"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ../Bin/Release/rux $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast, compiled, strongly typed, multi-paradigm programming language";
    homepage = "https://rux-lang.dev";
    license = licenses.mit;
    maintainers = with maintainers; [
      KirCK
      lukas-sgx
    ];
    mainProgram = "rux";
    platforms = platforms.all;
  };
})
