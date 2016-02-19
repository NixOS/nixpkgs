{ stdenv, fetchFromGitHub, python3Packages }:

let 
  version = "0.2.3"; 
in

python3Packages.buildPythonApplication rec {
  
  # Do not prefix name with python specific version identifier.
  namePrefix = "";

  name = "peru-${version}";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = "${version}";
    sha256 = "04bnaly50qmzkj0shdag94n8vr3ggarlqdny5zdb8nh31fqgln8b";
  };

  pythonPath = with python3Packages; [ pyyaml docopt ];

  meta = {
    homepage = https://github.com/buildinspace/peru;
    description = "A tool for including other people's code in your projects";
    license = stdenv.lib.licenses.mit;
  };
}