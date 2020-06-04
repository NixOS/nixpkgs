{ callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "v${version}";
    sha256 = "16s09d2kpw0v0kyr2ada99qmsi0pqnsiis22mzq69hay0hdg8p1n";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "1i GITSTATUS_DAEMON=$out/bin/gitstatusd" gitstatus.plugin.zsh
  '';
  installPhase = ''
    install -Dm755 usrbin/gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = "https://github.com/romkatv/gitstatus";
    license = [ licenses.gpl3 ];
    maintainers = with maintainers; [ mmlb hexa ];
  };
}
