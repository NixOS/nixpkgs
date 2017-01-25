{ python3Packages, fetchurl, lib }:

python3Packages.buildPythonApplication rec {
  version = "2.1.27";
  name = "cheat-${version}";

  propagatedBuildInputs = with python3Packages; [ docopt pygments ];

  src = fetchurl {
    url = "mirror://pypi/c/cheat/${name}.tar.gz";
    sha256 = "1mrrfwd4ivas0alfkhjryxxzf24a4ngk8c6n2zlfb8ziwf7czcqd";
  };
  # no tests available
  doCheck = false;

  meta = {
    description = "cheat allows you to create and view interactive cheatsheets on the command-line";
    maintainers = with lib.maintainers; [ mic92 ];
    license = with lib.licenses; [gpl3 mit];
    homepage = "https://github.com/chrisallenlane/cheat";
  };
}
