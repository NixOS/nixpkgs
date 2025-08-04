{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "swarm";
  version = "0-unstable-2019-03-11";

  src = fetchFromGitHub {
    owner = "nimble-code";
    repo = "swarm";
    rev = "4b36ed83c8fbb074f2dc5777fe1c0ab4d73cc7d9";
    sha256 = "18zwlwsiiksivjpg6agmbmg0zsw2fl9475ss66b6pgcsya2q4afs";
  };

  installPhase = ''
    install -Dm755 Src/swarm $out/bin/swarm
    install -Dm644 Doc/swarm.1 $out/share/man/man1/swarm.1
  '';

  meta = {
    description = "Verification script generator for Spin";
    mainProgram = "swarm";
    homepage = "http://spinroot.com/";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
