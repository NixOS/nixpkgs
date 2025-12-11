{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kitget";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "adamperkowski";
    repo = "kitget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i26nu5SkcPhqwh+/bw1rz7h8K2u+hhSsOGiLj3sF1RQ=";
  };

  cargoHash = "sha256-KARJV8SdbNa4tUuwyyfrLKdsj9fPF10MpL9hDGOQLm4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # the project doesn't implement any tests
  doCheck = false;

  meta = {
    description = "Display and customize cat images in your terminal";
    homepage = "https://github.com/adamperkowski/kitget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamperkowski ];
    mainProgram = "kitget";
    platforms = lib.platforms.linux;
  };
})
