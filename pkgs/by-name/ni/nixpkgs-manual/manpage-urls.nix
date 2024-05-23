{
  runCommand,
  testers,
  cacert,
  python3,
}:

testers.invalidateFetcherByDrvHash (
  {
    name ? "manual_check-manpage-urls",
    script ? ../../../../doc/tests/manpage-urls.py,
    urlsFile ? ../../../../doc/manpage-urls.json,
  }:
  runCommand name
    {
      nativeBuildInputs = [
        cacert
        (python3.withPackages (p: [
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
