{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blogr-cli";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "blogr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rK1+LkAqti7VfJRKmvDxDtiAHOnnzrDowPDNxF4azDs=";
  };

  cargoHash = "sha256-qRjObQBrJNXCOSQC6nlrxeRQiWbjQ297accEHgCuRLI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Write, edit, and publish your blog without ever leaving your terminal";
    homepage = "https://github.com/bahdotsh/blogr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fnl ];
    mainProgram = "blogr";
  };
})
