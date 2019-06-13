{stdenv, git, less, fetchFromGitHub, makeWrapper
# utillinuxMinimal is included because we need the column command
, utillinux
}:

stdenv.mkDerivation rec {
  name = "git-recent-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-recent";
    rev = "v${version}";
    sha256 = "06r1jzmzdv3d4vxdh5qyf5g5rgavxfmh2rpbs7a7byg3k7d77hpn";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin
    cp git-recent $out/bin
    wrapProgram $out/bin/git-recent \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git less utillinux ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/paulirish/git-recent;
    description = "See your latest local git branches, formatted real fancy";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.jlesquembre ];
  };
}
