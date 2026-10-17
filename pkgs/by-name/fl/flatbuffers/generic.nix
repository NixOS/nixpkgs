{
  version,
  hash,
}:
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flatbuffers";

  inherit version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    tag = "v${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DFLATBUFFERS_BUILD_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
    "-DFLATBUFFERS_OSX_BUILD_UNIVERSAL=OFF"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkTarget = "test";

  meta = {
    description = "Memory Efficient Serialization Library";
    longDescription = ''
      FlatBuffers is an efficient cross platform serialization library for
      games and other memory constrained apps. It allows you to directly
      access serialized data without unpacking/parsing it first, while still
      having great forwards/backwards compatibility.
    '';
    homepage = "https://google.github.io/flatbuffers/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.teh ];
    mainProgram = "flatc";
    platforms = lib.platforms.unix;
  };
})
