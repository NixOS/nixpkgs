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
    sha256 = "1742i15qfsbf49c4r837wz35c1p7yafvz7ar6vmgcj6cmfwr8jb4";
  };

  buildInputs = [
    zlib
    gmp
  ];

  makeFlags = [ "r" ];
  installPhase = ''
    install -Dm0755 open-wbo_release $out/bin/open-wbo
  '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "State-of-the-art MaxSAT and Pseudo-Boolean solver";
    mainProgram = "open-wbo";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://sat.inesc-id.pt/open-wbo/";
  };
}
