{ stdenv, fetchFromGitHub, git, nettools, perl }:

stdenv.mkDerivation rec {
  name = "gitolite-${version}";
  version = "3.6.7";

  src = fetchFromGitHub {
    owner = "sitaramc";
    repo = "gitolite";
    rev = "9123ae44b14b9df423a7bf1e693e05865ca320ac";
    sha256 = "0rmyzr66lxh2ildf3h1nh3hh2ndwk21rjdin50r5vhwbdd7jg8vb";
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
