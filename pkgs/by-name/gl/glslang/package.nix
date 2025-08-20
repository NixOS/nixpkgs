{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  jq,
  python3,
  spirv-headers,
  spirv-tools,
}:
stdenv.mkDerivation rec {
  pname = "glslang";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = version;
    hash = "sha256-QXNecJ6SDeWpRjzHRTdPJHob1H3q2HZmWuL2zBt2Tlw=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  # These get set at all-packages, keep onto them for child drvs
  passthru = {
    spirv-tools = spirv-tools;
    spirv-headers = spirv-headers;
  };

  nativeBuildInputs = [
    cmake
    python3
    bison
    jq
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  # This is a dirty fix for lib/cmake/SPIRVTargets.cmake:51 which includes this directory
  postInstall = ''
    mkdir -p $dev/include/External
    moveToOutput lib/pkgconfig "''${!outputDev}"
    moveToOutput lib/cmake "''${!outputDev}"
  '';

  # Fix the paths in .pc, even though it's unclear if these .pc are really useful.
  postFixup = ''
    substituteInPlace $dev/lib/pkgconfig/*.pc \
      --replace-fail '=''${prefix}//' '=/' \
      --replace-fail "includedir=$dev/$dev" "includedir=$dev"

    # add a symlink for backwards compatibility
    ln -s $bin/bin/glslang $bin/bin/glslangValidator
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ralith ];
  };
}
