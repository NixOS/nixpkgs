{ lib, stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.33.0";

  src = fetchurl {
    url = "https://github.com/newren/git-filter-repo/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-e88R2hNLvYKkFx9/soo6t7xNR4/o7Do9lYDku9wy5uk=";
  };

  buildInputs = [ pythonPackages.python ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin git-filter-repo
    install -Dm644 -t $out/share/man/man1 Documentation/man1/git-filter-repo.1
  '';

  meta = with lib; {
    homepage = "https://github.com/newren/git-filter-repo";
    description = "Quickly rewrite git repository history (filter-branch replacement)";
    license = licenses.mit;
    inherit (pythonPackages.python.meta) platforms;
    maintainers = [ maintainers.marsam ];
  };
}
