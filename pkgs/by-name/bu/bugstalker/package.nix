{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libunwind,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bugstalker";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c3NyYDz+Ha5jHTpXLw9xsY+h0NjW9Uvpyn2PStmahKA=";
  };

  cargoHash = "sha256-/FSV/avsg7kbgtinmKBb0+gemLFZdSE+A+tfLvtfNas=";

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
