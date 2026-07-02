{
  lib,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-quickfix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "siedentop";
    repo = "git-quickfix";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IAjet/bDG/Hf/whS+yrEQSquj8s5DEmFis+5ysLLuxs=";
  };

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    zlib
  ];

  cargoHash = "sha256-2VhbvhGeQHAbQLW0iBAgl0ICAX/X+PnwcGdodJG2Hsw=";

  meta = {
    description = "Commit changes in your git repository to a new branch without leaving the current branch";
    homepage = "https://github.com/siedentop/git-quickfix";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-quickfix";
  };
})
