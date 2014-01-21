{ stdenv, fetchgit, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "mailpile-dev";

  src = fetchgit {
    url = "https://github.com/pagekite/Mailpile.git";
    rev = "59b96150822780138ab3567502952caadbc1d73e";
    sha256 = "2edf82cbe6d3f17ba776fb5a70caa553f646db30ce207ab957038d845a9677e1";
  };

  propagatedBuildInputs = with pythonPackages; [
    pillow jinja2 pythonPackages."lxml-2.3.6" python.modules.readline or null];

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
