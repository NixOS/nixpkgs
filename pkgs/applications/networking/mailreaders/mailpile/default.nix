{ stdenv, fetchgit, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "mailpile-dev";

  src = fetchgit {
    url = "https://github.com/pagekite/Mailpile.git";
    rev = "cbb3bbf1f1da653124e63e11a51a6864dcb534a0";
    sha256 = "1m2qkhcygidxqnnj2ajsxv8y5wjyp5il3919sl3vyl47gx02xa8j";
  };

  propagatedBuildInputs = with pythonPackages; [
    pillow jinja2 spambayes pythonPackages."lxml-2.3.6" python.modules.readline or null];

  meta = with stdenv.lib; {
    description = "A modern, fast web-mail client with user-friendly encryption and privacy features";
    homepage = https://www.mailpile.is/;
    license = map (getAttr "shortName") [ licenses.asl20 licenses.agpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
