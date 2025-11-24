{ runTest }:

{
  clamonacc = runTest ./clamonacc.nix;
  tcpsocket = runTest ./tcpsocket.nix;
}
