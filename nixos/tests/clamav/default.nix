{ runTest }:

{
  clamonacc = runTest ./clamonacc.nix;
  tcpsocket = runTest ./tcpsocket.nix;
  multiple-tcp-addr = runTest ./multiple-tcp-addr.nix;
}
