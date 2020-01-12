{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation {
  pname = "gitstatus";
  version = "unstable-2019-12-18";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "8ae9c17a60158dcf91f56d9167493e3988a5e921";
    sha256 = "1czjwsgbmxd1d656srs3n6wj6bmqr8p3aw5gw61q4wdxw3mni2a6";
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

    maintainers = [ maintainers.mmlb ];
  };
}
