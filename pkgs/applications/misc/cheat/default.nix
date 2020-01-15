{ stdenv, python3, fetchFromGitHub }:

with python3.pkgs;
buildPythonApplication rec {
  pname = "cheat";
  version = "2.5.1";

  propagatedBuildInputs = [ docopt pygments termcolor ];

  src = fetchFromGitHub {
    owner = "chrisallenlane";
    repo = "cheat";
    rev = version;
    sha256 = "1i543hvg1yizamfd83bawflfcb500hvc72i59ikck8j1hjk50hsl";
  };
  # no tests available
  doCheck = false;

  postInstall = ''
    install -D man1/cheat.1.gz $out/share/man/man1/cheat.1.gz
    mv $out/${python3.sitePackages}/etc $out/
    mv $out/${python3.sitePackages}/usr/share/* $out/share/
    rm -r $out/${python3.sitePackages}/usr
  '';

  makeWrapperArgs = [
    "--suffix" "CHEAT_PATH" ":" "$out/share/cheat"
  ];

  meta = with stdenv.lib; {
    description = "cheat allows you to create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    homepage = https://github.com/chrisallenlane/cheat;
  };
}
