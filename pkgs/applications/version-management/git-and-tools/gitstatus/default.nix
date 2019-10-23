{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation {
  pname = "gitstatus";
  version = "unstable-2019-05-06";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "9c791f93c23c04dadfab8b4309a863b62a6ee424";
    sha256 = "0jbdrgl62x6j920h72n2q6304fb6gdgnmllpv4aa76m13b9qhgq6";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "s|local daemon.*|local daemon=$out/bin/gitstatusd|" gitstatus.plugin.zsh
  '';
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = [ maintainers.mmlb ];
  };
}
