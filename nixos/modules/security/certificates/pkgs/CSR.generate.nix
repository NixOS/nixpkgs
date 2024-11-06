{
  lib,
  writeShellApplication,
  openssl,
  specification,
  privateKeyPath,
  opensslConfig
}:
let
  args = {
    config = opensslConfig;
    outform = "PEM";
    batch = true;
    new = true;
    key = privateKeyPath;
  };
  _args = lib.cli.toGNUCommandLineShell {
    mkOptionName = k: "-${k}";
  } args;
in
  writeShellApplication {
    name = "certificate-${specification.name}-csr";
    runtimeInputs = [
      openssl
    ];
    text = ''
      openssl req ${_args}
    '';
  }