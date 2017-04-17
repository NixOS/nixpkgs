{ python3Packages, fetchurl, lib }:

python3Packages.buildPythonApplication rec {
  version = "2.2.0";
  name = "cheat-${version}";

  propagatedBuildInputs = with python3Packages; [ docopt pygments ];

  src = fetchurl {
    url = "mirror://pypi/c/cheat/${name}.tar.gz";
    sha256 = "16pg1bgyfjvzpm2rbi411ckf3gljg9v1vzd5qhp23g69ch6yr138";
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
