{
  lib,
  rustPlatform,
  fetchFromGitLab,
  protobuf,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bark-ffi-go";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = "ark-bitcoin";
    repo = "bark-ffi-bindings";
    rev = "66d047f7ee08c2bca3675605ea7a88bc8b50adb3";
    hash = "sha256-Dq4DfRYb5kVmdBJ6J909Z8zXOTzv6JhUBJ3yE/jXN24=";
  };

  sourceRoot = "${finalAttrs.src.name}/golang/rust";

  cargoHash = "sha256-K4/9rp9ktZU67TzaHYO655CgzasUG+iH3vfiK7ccVto=";

  cargoBuildFlags = [ "--lib" ];

  doCheck = false;

  buildInputs = [ sqlite ];

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
