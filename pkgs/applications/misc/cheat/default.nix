{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "cheat";
  version = "2.2.2";

  propagatedBuildInputs = [ docopt pygments ];

  src = fetchFromGitHub {
    owner = "chrisallenlane";
    repo = "cheat";
    rev = version;
    sha256 = "1da4m4n6nivjakpll6jj0aszrv24g2zax74034lzpv3pbh84fvas";
  };
  # no tests available
  doCheck = false;

  postInstall = ''
    install -D man1/cheat.1.gz $out/share/man/man1/cheat.1.gz
  '';

  meta = with stdenv.lib; {
    description = "cheat allows you to create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [gpl3 mit];
    homepage = https://github.com/chrisallenlane/cheat;
  };
}
