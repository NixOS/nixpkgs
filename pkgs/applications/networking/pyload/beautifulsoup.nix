{ pythonPackages, isPy3k, pkgs }:

pythonPackages.buildPythonPackage {
  name = "beautifulsoup-3.2.1";
  disabled = isPy3k;

  src = pkgs.fetchurl {
    url = "http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.2.1.tar.gz";
    sha256 = "1nshbcpdn0jpcj51x0spzjp519pkmqz0n0748j7dgpz70zlqbfpm";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    homepage = http://www.crummy.com/software/BeautifulSoup/;
    license = "bsd";
    description = "Undemanding HTML/XML parser";
  };
}
