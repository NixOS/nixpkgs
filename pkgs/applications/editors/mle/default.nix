{ lib
, stdenv
, fetchFromGitHub
, pcre2
, uthash
, lua5_4
, makeWrapper
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "mle";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "mle";
    rev = "v${version}";
    sha256 = "0rkk7mh6w5y1lrbdv7wmxdgl5cqzpzw0p26adazkqlfdyb6wbj9k";
  };

  # Fix location of Lua 5.4 header and library
  postPatch = ''
    substituteInPlace Makefile --replace "-llua5.4" "-llua";
    substituteInPlace mle.h    --replace "<lua5.4/" "<";
    patchShebangs tests/*
  '';

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ pcre2 uthash lua5_4 ];

  doCheck = true;

  installFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    installManPage mle.1
  '';

  meta = with lib; {
    description = "Small, flexible, terminal-based text editor";
    homepage = "https://github.com/adsr/mle";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ adsr ];
    mainProgram = "mle";
  };
}
