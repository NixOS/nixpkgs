{ stdenv, fetchgit, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "mailpile-dev";

  src = fetchgit {
    url = "https://github.com/pagekite/Mailpile.git";
    rev = "6e19c1942541dbdefb5155db5f2583bf3ed22aeb";
    sha256 = "04idlbjkasigq3vslcv33kg21rjyklm2yl8pyrf5h94lzabbl1fs";
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
