{ callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation {
  pname = "gitstatus";
  version = "unstable-2020-02-26";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "c0e5a24299c1a1a71434dac1de6ea650e80fbe49";
    sha256 = "0fj84cvr5a895jqgg86raakx6lqyyhahf1dgzgx05y2gfvnxxh8m";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "1i GITSTATUS_DAEMON=$out/bin/gitstatusd" gitstatus.plugin.zsh
  '';
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = with maintainers; [ mmlb hexa ];
  };
}
