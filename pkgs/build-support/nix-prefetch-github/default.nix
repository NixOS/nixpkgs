{ python3
, fetchFromGitHub
, stdenv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-prefetch-github";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "1m1d1fzacvwprfvhxih1hzr1m0y1jjxiznf8p8b3bi5a41yzvrrl";
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
