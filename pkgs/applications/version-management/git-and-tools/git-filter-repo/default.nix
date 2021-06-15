{ lib, stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-filter-repo";
  version = "2.32.0";

  src = fetchurl {
    url = "https://github.com/newren/git-filter-repo/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-CztFSyeKM9Bmcf0eSrLHH3vHGepd8WXPvcAACT+vFps=";
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
