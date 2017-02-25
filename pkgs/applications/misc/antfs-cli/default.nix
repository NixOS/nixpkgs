{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "antfs-cli-unstable-2017-02-11";

  meta = with stdenv.lib; {
    homepage = "https://github.com/Tigge/antfs-cli";
    description = "Extracts FIT files from ANT-FS based sport watches";
    license = licenses.mit;
    platforms = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "antfs-cli";
    rev = "85a6cc6fe6fc0ec38399f5aa30fb39177c565b52";
    sha256 = "0v8y64kldfbs809j1g9d75dd1vxq7mfxnp4b45pz8anpxhjf64fy";
  };

  propagatedBuildInputs = [ pythonPackages.openant ];
}
