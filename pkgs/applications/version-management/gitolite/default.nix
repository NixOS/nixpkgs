{ stdenv, fetchFromGitHub, git, lib, makeWrapper, nettools, perl }:

stdenv.mkDerivation rec {
  pname = "gitolite";
  version = "3.6.12";

  src = fetchFromGitHub {
    owner = "sitaramc";
    repo = "gitolite";
    rev = "v${version}";
    sha256 = "05xw1pmagvkrbzga5pgl3xk9qyc6b5x73f842454f3w9ijspa8zy";
  };

  buildInputs = [ nettools perl ];
  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ git ];

  dontBuild = true;

  postPatch = ''
    substituteInPlace ./install --replace " 2>/dev/null" ""
    substituteInPlace src/lib/Gitolite/Hooks/PostUpdate.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Hooks/Update.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Setup.pm \
      --replace hostname "${nettools}/bin/hostname"
  '';

  postFixup = ''
    wrapProgram $out/bin/gitolite-shell \
      --prefix PATH : "${git}/bin"
  '';

  installPhase = ''
    mkdir -p $out/bin
    perl ./install -to $out/bin
    echo ${version} > $out/bin/VERSION
  '';

  meta = with stdenv.lib; {
    description = "Finely-grained git repository hosting";
    homepage    = "https://gitolite.com/gitolite/index.html";
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.lassulus maintainers.tomberek ];
  };
}
