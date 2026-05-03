{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.8.7";
  pname = "clib";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    owner = "clibs";
    repo = "clib";
    sha256 = "sha256-uL8prMk2DrYLjCmZW8DdbCg5FJ5uksT3vIATyOW2ZzY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ curl ];

  meta = {
    description = "C micro-package manager";
    homepage = "https://github.com/clibs/clib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jb55 ];
    platforms = lib.platforms.all;
  };
})
