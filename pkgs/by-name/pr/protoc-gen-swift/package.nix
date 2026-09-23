{
  lib,
  fetchFromGitHub,
  swift,
  swiftpm,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-swift";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-protobuf";
    rev = "${finalAttrs.version}";
    hash = "sha256-Kit/kQDNs0ohtaNC0xWxG6o0vNGUWWE++YK1JP2o8OM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/protoc-gen-swift $out/bin/protoc-gen-swift
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protobuf plugin for generating Swift code";
    homepage = "https://github.com/apple/swift-protobuf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matteopacini ];
    mainProgram = "protoc-gen-swift";
    inherit (swift.meta) platforms badPlatforms;
  };
})
