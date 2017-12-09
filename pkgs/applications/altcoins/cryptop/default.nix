{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "cryptop";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0akrrz735vjfrm78plwyg84vabj0x3qficq9xxmy9kr40fhdkzpb";
  };

  propagatedBuildInputs = [ python3.pkgs.requests python3.pkgs.requests-cache ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = https://github.com/huwwp/cryptop;
    description = "Command line Cryptocurrency Portfolio";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
