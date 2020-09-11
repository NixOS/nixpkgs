{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.28.0";

  src = fetchurl {
    url = "https://github.com/newren/git-filter-repo/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0sa6h6k1mnhx8p8w5d88gx7cqbnxaazfj1dv47c107fk70hqvvpx";
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
