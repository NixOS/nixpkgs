{ python3
, fetchFromGitHub
, stdenv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-prefetch-github";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "1v4w7xs8wxgl36vb2cnyj219mqvximkvvw46h4fp25vi2g3f9h8d";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    click
    effect
    jinja2
    requests
  ];
  meta = with stdenv.lib; {
    description = "Prefetch sources from github";
    homepage = https://github.com/seppeljordan/nix-prefetch-github;
    license = licenses.gpl3;
    maintainers = [ maintainers.seppeljordan ];
  };
}
