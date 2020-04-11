{ stdenv, fetchFromGitHub, python3, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "electrum-personal-server";
  version = "0.2.0";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "chris-belcher";
    repo = "electrum-personal-server";
    rev = "eps-v${version}";
    sha256 = "0ysb0jhklv8m2bvkzm0w939vjdvwmc7zn53rai7yilvragzaq2w6";
  };

  propagatedBuildInputs = with python3Packages; [ wheel pytestrunner setuptools ];

  meta = with stdenv.lib; {
    description = "An lightweight, single-user implementation of the Electrum server protocol";
    longDescription = ''
      Electrum Personal Server aims to make using Electrum bitcoin wallet 
      more secure and more private. It makes it easy to connect your 
      Electrum wallet to your own full node.
    '';
    homepage = "https://github.com/chris-belcher/electrum-personal-server";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ emmanuelrosa ];
  };
}
