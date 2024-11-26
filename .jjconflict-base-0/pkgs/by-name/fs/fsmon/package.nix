{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = "refs/tags/${version}";
    hash = "sha256-m0Bu1lT3KH4ytkpEakI7fvRHV1kmgaXS71+wmNGmEl8=";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    description = "FileSystem Monitor utility";
    homepage = "https://github.com/nowsecure/fsmon";
    changelog = "https://github.com/nowsecure/fsmon/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
    mainProgram = "fsmon";
  };
}
