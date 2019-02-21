{ python3
, fetchFromGitHub
, stdenv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-prefetch-github";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "06vxy26d1s7azb9amxdf83i8kxgs2sbjsy0d3mjhwffga13b4igc";
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
