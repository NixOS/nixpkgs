# This older version only exists because `ceph` needs it, see `cryptography.nix`.
{
  buildPythonPackage,
  fetchPypi,
  lib,
  cryptography,
}:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;
  format = "setuptools";

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
    hash = "sha256-hGBwa1tdDOSoVXHKM4nPiPcAu2oMYTPcn+D1ovW9oEE=";
  };

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [ nh2 ];
  };
}
