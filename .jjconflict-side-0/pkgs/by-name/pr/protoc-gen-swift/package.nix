{
  lib,
  fetchFromGitHub,
  swiftPackages,
  swift,
  swiftpm,
  nix-update-script,
}:
let
  stdenv = swiftPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-swift";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-protobuf";
    rev = "${finalAttrs.version}";
    hash = "sha256-YOEr73xDjNrc4TTkIBY8AdAUX2MBtF9ED1UF2IjTu44=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  # Not needed for darwin, as `apple-sdk` is implicit and part of the stdenv
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    swiftPackages.Foundation
    swiftPackages.Dispatch
  ];

  # swiftpm fails to found libdispatch.so on Linux
  LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [
      swiftPackages.Dispatch
    ]
  );

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
