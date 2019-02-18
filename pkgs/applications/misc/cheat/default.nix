{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "cheat";
  version = "2.3.1";

  propagatedBuildInputs = [ docopt pygments ];

  src = fetchFromGitHub {
    owner = "chrisallenlane";
    repo = "cheat";
    rev = version;
    sha256 = "1dcpjvbv648r8325qjf30m8b4cyrrjbzc2kvh40zy2mbjsa755zr";
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
