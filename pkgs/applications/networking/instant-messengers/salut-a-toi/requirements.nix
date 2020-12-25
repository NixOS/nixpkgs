{ fetchurl
, stdenv
, pythonPackages
}:

let
  buildPythonPackage = pythonPackages.buildPythonPackage;

  xe = buildPythonPackage rec {
    pname = "xe";
    version = "0.7.4";

    src = fetchurl {
      url = "http://www.blarg.net/%7Esteveha/${pname}-${version}.tar.gz";
      sha256 = "0v9878cl0y9cczdsr6xjy8v9l139lc23h4m5f86p4kpf2wlnpi42";
    };

    # error: invalid command 'test'
    doCheck = false;

    meta = {
      homepage = "http://home.blarg.net/~steveha/xe.html";
      description = "XML elements";
    };
  };

in {

  pyfeed = (buildPythonPackage rec {
    pname = "pyfeed";
    version = "0.7.4";

    src = fetchurl {
      url = "http://www.blarg.net/%7Esteveha/${pname}-${version}.tar.gz";
      sha256 = "1h4msq573m7wm46h3cqlx4rsn99f0l11rhdqgf50lv17j8a8vvy1";
    };

    propagatedBuildInputs = [ xe ];

    # error: invalid command 'test'
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "http://home.blarg.net/~steveha/pyfeed.html";
      description = "Tools for syndication feeds";
    };

  });

  wokkel = buildPythonPackage (rec {
    pname = "wokkel";
    version = "0.7.0";

    src = fetchurl {
      url = "http://wokkel.ik.nu/releases/${version}/${pname}-${version}.tar.gz";
      sha256 = "0rnshrzw8605x05mpd8ndrx3ri8h6cx713mp8sl4f04f4gcrz8ml";
    };

    propagatedBuildInputs = with pythonPackages; [twisted dateutil];

    meta = with stdenv.lib; {
      description = "Some (mainly XMPP-related) additions to twisted";
      homepage = "http://wokkel.ik.nu/";
      license = licenses.mit;
    };
  });

}
