{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "epr";
  version = "2.3.0b";

  src = fetchFromGitHub {
    owner = "wustho";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a6md3015284hzmx0sby5kl59p7lwv73sq7sid35vrr15zrl0aw7";
  };

  meta = with lib; {
    description = "CLI Epub Reader";
    homepage = "https://github.com/wustho/epr";
    license = licenses.mit;
    maintainers = [ maintainers.filalex77 ];
    platforms = platforms.all;
  };
}
