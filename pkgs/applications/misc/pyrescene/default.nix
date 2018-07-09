{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "pyrescene-${version}";
  version = "0.7";

  src = fetchurl {
    url = "https://bitbucket.org/Gfy/pyrescene/get/${version}.tar.gz";
    sha256 = "0cx25y150vvqk38j46i7g0npnvhh89drpjz2b0nlxhy6770g5025";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "port of ReScene .NET to the Python programming language";
    longDescription = ''
      ReScene is a mechanism for backing up and restoring the metadata from
      "scene" released RAR files. RAR archive volumes are rebuild using the
      stored metadata in the SRR file and the extracted files from the RAR
      archive.
    '';
    homepage = http://rescene.wikidot.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
