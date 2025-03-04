{
  writeShellApplication,
  bc,
  diffutils,
  findutils,
  coreutils,
  firmwarePaths ? [
    "/run/current-system/firmware"
  ],
}:
writeShellApplication {
  name = "edido";
  meta.description = "A tool to apply display configuration from `boot.kernelParams`.";
  runtimeInputs = [
    diffutils
    findutils
    coreutils
    bc
  ];
  text = ''
    FIRMWARE_PATH="''${FIRMWARE_PATH:-"${builtins.concatStringsSep ":" firmwarePaths}"}"
    ${builtins.readFile ./edido.sh}
  '';
}
