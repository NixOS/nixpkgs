{ stdenv, fetchurl, perl, git, fetchgit }:

stdenv.mkDerivation rec {
  name = "gitolite-${version}";
  version = "3.6.1";

  src = fetchgit {
    url    = "git://github.com/sitaramc/gitolite";
    rev    = "refs/tags/v${version}";
    sha256 = "47e0e9c3137b05af96c091494ba918d61d1d3396749a04d63e7949ebcc6c6dca";
    leaveDotGit = true;
  };

  buildInputs = [ perl git ];
  buildPhase = "true";

  patchPhase = ''
    substituteInPlace ./install --replace " 2>/dev/null" ""
    substituteInPlace src/lib/Gitolite/Hooks/PostUpdate.pm \
      --replace /usr/bin/perl "/usr/bin/env perl"
    substituteInPlace src/lib/Gitolite/Hooks/Update.pm \
      --replace /usr/bin/perl "/usr/bin/env perl"
  '';
  installPhase = ''
    mkdir -p $out/bin
    git tag v${version} # Gitolite requires a tag for the version information :/
    perl ./install -to $out/bin
  '';

  meta = {
    description = "Finely-grained git repository hosting";
    homepage    = "http://gitolite.com/gitolite/index.html";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
