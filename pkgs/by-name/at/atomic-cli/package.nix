{
  lib,
  runCommand,
  atomic-server,
}:

runCommand "atomic-cli"
  {
    pname = "atomic-cli";
    version = atomic-server.version;
    meta = {
      description = "Symlinked CLI tool for interacting with Atomic Data servers";
      homepage = atomic-server.meta.homepage;
      license = atomic-server.meta.license;
      mainProgram = "atomic-cli";
      maintainers = [ lib.maintainers.oluchitheanalyst ];
      platforms = lib.platforms.all;
      teams = with lib.teams; [ ngi ];
    };
  }
  ''
    mkdir -p "$out/bin"
    ln -s "${atomic-server}/bin/atomic-cli" "$out/bin/atomic-cli"
  ''
