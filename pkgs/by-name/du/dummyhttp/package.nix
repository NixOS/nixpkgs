{
  lib,
  cacert,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dummyhttp";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JfI6r1hSCZePzUFpmR1vBU4qHXAvfSL5snF/X2zfN4o=";
  };

  nativeBuildInputs = [
    cacert
  ];

  cargoHash = "sha256-klUifN8I0c7SnsH1V+LdUKJYimTnGV3QMRjEnUAVkfI=";

  meta = {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "dummyhttp";
  };
})
