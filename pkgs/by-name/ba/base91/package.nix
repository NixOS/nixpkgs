{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "base91";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lx569OtNU0z884763FSByH0yXIq6GzeXyp5NVvMejco="; # update as needed
  };

  makeFlags = [
    "CC=cc"
    "-C"
    "src"
    "all"
  ];
  installFlags = [
    "-C"
    "src"
    "install"
    "prefix=$(out)"
  ];

  meta = {
    description = "CLI tool for encoding binary data as ASCII characters";
    homepage = "https://github.com/douzebis/base91";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    platforms = lib.platforms.unix;
  };
})
