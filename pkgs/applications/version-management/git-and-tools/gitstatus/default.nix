{ callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation {
  pname = "gitstatus";
  version = "unstable-2020-03-15";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "c07996bc3ea1912652f52a816b830a5a3ee9b49c";
    sha256 = "07s8hwx3i5mnafi2xfim44z3q2nsvlcibfdxj17w8mkjhfpywi00";
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
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = with maintainers; [ mmlb hexa ];
  };
}
