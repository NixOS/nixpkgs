{
  cmake,
  fetchFromGitHub,
  gtest,
  lib,
  protobuf,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protobuf-matchers";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "inazarenko";
    repo = "protobuf-matchers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aIEqmA4JwnGHY80Ehr9tgyxzhAk1nAdiVtPbsI0P0Aw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
      'target_include_directories(protobuf-matchers PUBLIC ''${CMAKE_CURRENT_SOURCE_DIR})' \
      'target_include_directories(protobuf-matchers PUBLIC $<BUILD_INTERFACE:''${CMAKE_CURRENT_SOURCE_DIR}> $<INSTALL_INTERFACE:include>)'
    echo 'target_sources(protobuf-matchers PUBLIC FILE_SET HEADERS
        FILES protobuf-matchers/protocol-buffer-matchers.h)' >> CMakeLists.txt
    echo 'install(TARGETS protobuf-matchers
        FILE_SET HEADERS DESTINATION include)' >> CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    gtest
    protobuf
  ];

  meta = {
    description = "Protocol buffer matchers for gMock/gTest";
    homepage = "https://github.com/inazarenko/protobuf-matchers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
})
