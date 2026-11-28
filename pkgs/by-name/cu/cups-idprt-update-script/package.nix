{
  lib,
  writeShellApplication,
  curl,
  coreutils,
  gnugrep,
  gnused,
  nix,
}:

# Usage in a package: passthru.updateScript = [ (lib.getExe cups-idprt-update-script) "<model>" ];
#
# The driver download URLs on idprt.com embed a date and a random token, so
# the current one is scraped from the download page of any model that uses the
# driver.
writeShellApplication {
  name = "cups-idprt-update-script";
  runtimeInputs = [
    curl
    coreutils
    gnugrep
    gnused
    nix
  ];
  text = builtins.readFile ./update.sh;

  meta = {
    description = "Update script for the iDPRT CUPS driver packages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "cups-idprt-update-script";
  };
}
