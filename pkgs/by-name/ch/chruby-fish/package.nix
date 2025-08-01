{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chruby-fish";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "JeanMertz";
    repo = "chruby-fish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lk6XvmKgEjXVjO3jMjJkCxoX7TGMxq3ib0Ohh/J4IPI=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Thin wrapper around chruby to make it work with the Fish shell";
    homepage = "https://github.com/JeanMertz/chruby-fish";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.cohei ];
  };
})
