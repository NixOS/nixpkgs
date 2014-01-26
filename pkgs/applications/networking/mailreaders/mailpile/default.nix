{ stdenv, fetchgit, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "mailpile-dev";

  src = fetchgit {
    url = "https://github.com/pagekite/Mailpile.git";
    rev = "695a25061a5220d4f0fd6ec3de4ccd9ae4c05a92";
    sha256 = "0il9idfpnzb1a5cg3p9zrd6fnw2dhrqr6c3gzq1m06snw8jx9fpc";
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
