{ callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "v${version}";
    sha256 = "1kspz2fhryyjhn6gqf029rv0386a1ga08sf6g0l6smivw628k71l";
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
