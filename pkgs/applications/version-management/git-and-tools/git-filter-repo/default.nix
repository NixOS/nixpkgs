{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.27.0";

  src = fetchurl {
    url = "https://github.com/newren/git-filter-repo/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "1vry0pqwi0p82m3wflr0wyf88wn75l049w18xf9f5z43xd9vpva1";
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
    inherit (pythonPackages.python.meta) platforms;
    maintainers = [ maintainers.marsam ];
  };
}
