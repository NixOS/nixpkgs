{
  lib,
  rustPlatform,
  fetchFromGitLab,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bark-ffi-go";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "ark-bitcoin";
    repo = "bark-ffi-bindings";
    rev = "3c626a43d7523c4d19e867bd453ec80c541780c7";
    hash = "sha256-PbGTbVMO2L+gQpZQewkR0uo6fxqrVUjT/eAsnz2o/u4=";
  };

  sourceRoot = "${finalAttrs.src.name}/golang/rust";

  cargoHash = "sha256-OED+NqNt71771UDZ1M8Ks/Yfx8YNjfL246FKMeLFfLg=";

  cargoBuildFlags = [ "--lib" ];

  doCheck = false;

  nativeBuildInputs = [
    protobuf
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 target/*/release/libbark_ffi_go.a \
      $out/lib/libbark_ffi_go.a

    runHook postInstall
  '';

  meta = {
    description = "Go bindings static library for Bark";
    homepage = "https://gitlab.com/ark-bitcoin/bark-ffi-bindings";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bleetube ];
  };
})
