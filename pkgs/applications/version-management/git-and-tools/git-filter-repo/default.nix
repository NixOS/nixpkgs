{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.26.0";

  src = fetchurl {
    url = "https://github.com/newren/git-filter-repo/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "15d07i66b090bhjfj9s4s2s38k75mhxmddzyn44bnnyb967w6yjk";
  };

  buildInputs = [ pythonPackages.python ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin git-filter-repo
    install -Dm644 -t $out/share/man/man1 Documentation/man1/git-filter-repo.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/newren/git-filter-repo";
    description = "Quickly rewrite git repository history (filter-branch replacement)";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
