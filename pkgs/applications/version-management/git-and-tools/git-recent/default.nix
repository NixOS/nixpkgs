{stdenv, git, less, fetchFromGitHub, makeWrapper
# utillinuxMinimal is included because we need the column command
, utillinux ? null
}:

assert stdenv.isLinux -> utillinux != null;

let
  binpath = stdenv.lib.makeBinPath
    ([ git less ]
    ++ stdenv.lib.optional (utillinux != null) utillinux);
in stdenv.mkDerivation rec {
  name = "git-recent-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-recent";
    rev = "v${version}";
    sha256 = "0dbnm5b2v04fy0jgzphm3xvz9scx0n4p10fw8wjd0cy56308h79k";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin
    cp git-recent $out/bin
    wrapProgram $out/bin/git-recent \
      --prefix PATH : "${binpath}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/paulirish/git-recent;
    description = "See your latest local git branches, formatted real fancy";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.jlesquembre ];
  };
}
