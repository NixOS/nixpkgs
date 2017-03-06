{ python3Packages, fetchurl, lib }:

python3Packages.buildPythonApplication rec {
  version = "2.1.28";
  name = "cheat-${version}";

  propagatedBuildInputs = with python3Packages; [ docopt pygments ];

  src = fetchurl {
    url = "mirror://pypi/c/cheat/${name}.tar.gz";
    sha256 = "1a5c5f3dx3dmmvv75q2w6v2xb1i6733c0f8knr6spapvlim5i0c5";
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
