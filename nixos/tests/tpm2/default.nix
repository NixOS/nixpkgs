{ runTest }:
{
  abrmd = runTest ./tpm2-abrmd.nix;
  tpmrm = runTest ./tpm2-tpmrm.nix;
}
