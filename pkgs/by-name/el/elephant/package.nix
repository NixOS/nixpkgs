{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  fd,
  makeWrapper,
  protoc-gen-go,
  protobuf,
}:
buildGo125Module (finalAttrs: {
  pname = "elephant";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "elephant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KsftBsOJ22B4TU24mmIUyVRMBnjR7Eh5QJsT9aiZ58k=";
  };

  vendorHash = "sha256-shdrMMCdAntH/V1wWHG6kBYWf3Kn4DNimHyCtLrWIWE=";

  buildInputs = [
    protobuf
  ];

  nativeBuildInputs = [
    protoc-gen-go
    makeWrapper
  ];

  # Build from cmd/elephant/elephant.go
  subPackages = [
    "cmd/elephant"
  ];

  postFixup = ''
     wrapProgram $out/bin/elephant \
       --prefix PATH : ${lib.makeBinPath [ fd ]}
  '';

  meta = {
    description = "Data provider service and backend for building custom application launchers";
    homepage = "https://github.com/abenz1267/elephant";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
