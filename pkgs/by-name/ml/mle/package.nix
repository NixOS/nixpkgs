{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
  uthash,
  lua5_4,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mle";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "mle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xyelmIWqT4FmkFmI02XfdoIgkumQEso5Lf6oEaZP9yM=";
  };

  # Fix location of Lua 5.4 header and library
  postPatch = ''
    substituteInPlace Makefile --replace "-llua5.4" "-llua";
    substituteInPlace mle.h    --replace "<lua5.4/" "<";
    patchShebangs tests/*
  '';

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    pcre2
    uthash
    lua5_4
  ];

  doCheck = true;

  installFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    installManPage mle.1
  '';

  meta = {
    description = "Small, flexible, terminal-based text editor";
    homepage = "https://github.com/adsr/mle";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ adsr ];
    mainProgram = "mle";
  };
})
