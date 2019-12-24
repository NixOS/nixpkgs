{ python3
, fetchFromGitHub
, stdenv
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-prefetch-github";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "08vlwg9xcmqri0yxl79il1h2fzqflsbkkkwb4r7pipjn660b4nn5";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    click
    effect
    jinja2
  ];
  meta = with stdenv.lib; {
    description = "Prefetch sources from github";
    homepage = https://github.com/seppeljordan/nix-prefetch-github;
    license = licenses.gpl3;
    maintainers = [ maintainers.seppeljordan ];
  };
}
