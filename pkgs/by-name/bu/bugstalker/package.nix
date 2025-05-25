{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libunwind,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bugstalker";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8Iqg2coFsPQY3ws5MEC1LhTu+Z1lXeI3ccjgoBS454o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-a5YI6bOo/rsi9hZO1BcVMjJtdrYq2aHqxtlO3F+P+8s=";

  buildInputs = [ libunwind ];

  nativeBuildInputs = [ pkg-config ];

  # Tests require rustup.
  doCheck = false;

  meta = {
    description = "Rust debugger for Linux x86-64";
    homepage = "https://github.com/godzie44/BugStalker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "bs";
    platforms = [ "x86_64-linux" ];
  };
})
