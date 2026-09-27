{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "gsmlib";
  version = "0-unstable-2017-10-06";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "x-logLT";
    repo = "gsmlib";
    rev = "4f794b14450132f81673f7d3570c5a859aecf7ae";
    hash = "sha256-hdZRK4of0PS07den9qE7/o0VJT0GKRLcjYEpEpJUaJs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-std=c++14"
  ];

  meta = {
    description = "Library to access GSM mobile phones through GSM modems";
    homepage = "https://github.com/x-logLT/gsmlib";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.misuzu ];
  };
}
