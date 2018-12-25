{ stdenv, fetchFromGitHub, git, nettools, perl }:

stdenv.mkDerivation rec {
  name = "gitolite-${version}";
  version = "3.6.10";

  src = fetchFromGitHub {
    owner = "sitaramc";
    repo = "gitolite";
    rev = "v${version}";
    sha256 = "0p2697mn6rwm03ndlv7q137zczai82n41aplq1g006ii7f12xy8h";
  };

  buildInputs = [ git nettools perl ];

  dontBuild = true;

  patchPhase = ''
    substituteInPlace ./install --replace " 2>/dev/null" ""
    substituteInPlace src/lib/Gitolite/Hooks/PostUpdate.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Hooks/Update.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Setup.pm \
      --replace hostname "${nettools}/bin/hostname"
  '';

  installPhase = ''
    mkdir -p $out/bin
    perl ./install -to $out/bin
    echo ${version} > $out/bin/VERSION
  '';

  meta = with stdenv.lib; {
    description = "Finely-grained git repository hosting";
    homepage    = http://gitolite.com/gitolite/index.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.lassulus maintainers.tomberek ];
  };
}
