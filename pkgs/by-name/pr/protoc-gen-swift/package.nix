{
  stdenv,
  lib,
  fetchFromGitHub,
  swift,
  swiftpm,
  swiftPackages,
  nix-update-script,
}:
let
  inherit (swiftPackages) Foundation;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-swift";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-protobuf";
    rev = "${finalAttrs.version}";
    hash = "sha256-XIOXAaEEYXC1Ajs51eJaiW016qebTo11znmli1nxmQ0=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [ Foundation ];

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
