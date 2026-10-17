{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  gmp,
}:

stdenv.mkDerivation {
  pname = "open-wbo";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "sat-group";
    repo = "open-wbo";
    rev = "f193a3bd802551b13d6424bc1baba6ad35ec6ba6";
    hash = "sha256-ZEmUuavMSPbqNlmdv53y5wZWxudnoExYIm5ph0uIgpw=";
  };

  buildInputs = [
    zlib
    gmp
  ];

  makeFlags = [ "r" ];
  installPhase = ''
    install -Dm0755 open-wbo_release $out/bin/open-wbo
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "State-of-the-art MaxSAT and Pseudo-Boolean solver";
    mainProgram = "open-wbo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    homepage = "http://sat.inesc-id.pt/open-wbo/";
  };
}
