{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  libgit2,
  apple-sdk,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-today";
  version = "0.1.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bitSheriff";
    repo = "git-today";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jvXhIGyqlQjgZN/Gx/2vsvk1U3SDpypn0mBYumNCOow=";
  };

  cargoHash = "sha256-cnGyig8X9OgWFHR9pCIl4NdfjmGTQLWsXoNxEa92H50=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
    libgit2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
  ];

  env.LIBGIT2_SYS_USE_PKG_CONFIG = 1;

  meta = {
    description = "A tool to recap your daily git work";
    homepage = "https://github.com/bitSheriff/git-today";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bitSheriff ];
    mainProgram = "git-today";
  };
})
