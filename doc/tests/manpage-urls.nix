# To build this derivation, run `nix-build -A nixpkgs-manual.tests.manpage-urls`
{
  lib,
  runCommand,
  testers,
  cacert,
  python3,
}:

testers.invalidateFetcherByDrvHash (
  {
    name ? "manual_check-manpage-urls",
    script ? ./manpage-urls.py,
    urlsFile ? ../manpage-urls.json,
  }:
  runCommand name
    {
      nativeBuildInputs = [
        cacert
        (python3.pythonOnBuildForHost.withPackages (p: [
          p.aiohttp
          p.rich
          p.structlog
        ]))
      ];
      outputHash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="; # Empty output
    }
    ''
      python3 ${script} ${urlsFile}
      touch $out
    ''
) { }
