{ stdenv, fetchurl, git, nettools, perl }:

stdenv.mkDerivation rec {
  name = "gitolite-${version}";
  version = "3.6.5";

  src = fetchurl {
    url = "https://github.com/sitaramc/gitolite/archive/v${version}.tar.gz";
    sha256 = "0xpqg04gyr4dhdhxx5lbk61lwwd5ml32530bigg2qy663icngwqm";
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
  '';

  meta = with stdenv.lib; {
    description = "Finely-grained git repository hosting";
    homepage    = http://gitolite.com/gitolite/index.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.lassulus ];
  };
}
