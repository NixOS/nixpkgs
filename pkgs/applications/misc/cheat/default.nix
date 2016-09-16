{ python3Packages, fetchurl, lib }:

python3Packages.buildPythonApplication rec {
  version = "2.1.26";
  name = "cheat-${version}";

  propagatedBuildInputs = with python3Packages; [ docopt pygments ];

  src = fetchurl {
    url = "mirror://pypi/c/cheat/${name}.tar.gz";
    sha256 = "0yilm9ba6ll9wzh20gj3lg9mnc50q95m6sqmjp2vcghwgipdixpm";
  };

  meta = {
    description = "cheat allows you to create and view interactive cheatsheets on the command-line";
    maintainers = with lib.maintainers; [ mic92 ];
    license = with lib.licenses; [gpl3 mit];
    homepage = "https://github.com/chrisallenlane/cheat";
  };
}
