{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-mopify-${version}";

  version = "1.5.8";

  src = fetchurl {
    url = "https://github.com/dirkgroenen/mopidy-mopify/archive/${version}.tar.gz";
    sha256 = "1gq88i5hbyskwhqf51myndqgmrndkyy6gs022sc387fy3dwxmvn0";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy configobj ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dirkgroenen/mopidy-mopify;
    description = "A mopidy webclient based on the Spotify webbased interface";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
