{ lib, python2}:

python2.pkgs.buildPythonApplication rec {
  pname = "cryptop";
  version = "0.1.0";
  name = "${pname}-${version}";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "00glnlyig1aajh30knc5rnfbamwfxpg29js2db6mymjmfka8lbhh";
  };

  propagatedBuildInputs = [ python2.pkgs.requests ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = http://github.com/huwwp/cryptop;
    description = "Command line Cryptocurrency Portfolio";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
