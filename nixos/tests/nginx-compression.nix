{ lib, ... }:
let
  # defaultMimeTypes holds file extensions, selected by the property that nginx's mime.types maps
  # each one to a MIME type that gzip ought to cover. The test doesn't assert a specific
  # Content-Type but the actual file extension, so that if requesting test.rss, nginx already knows
  # this will have Content-Type: application/rss+xml and the test will check it is gzipped, without
  # hardcoding the content type.
  compressible = [
    "atom"
    "bmp"
    "css"
    "eot"
    "html"
    "ico"
    "js"
    "json"
    "rss"
    "svg"
    "txt"
    "wasm"
    "xhtml"
    "xml"
  ];

  # Formats that are already compressed and must be served verbatim.
  incompressible = [
    "jpg"
    "png"
    "zip"
  ];
in
{
  name = "nginx-compression";

  containers.machine =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        virtualHosts.default.root = pkgs.runCommandLocal "nginx-compression-testdir" { } ''
          mkdir "$out"
          for ext in ${lib.concatStringsSep " " (compressible ++ incompressible)}; do
            # Well past gzip_min_length, and trivially compressible.
            printf 'the quick brown fox jumps over the lazy dog\n%.0s' {1..32} > "$out/test.$ext"
          done
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)

    def probe(ext):
        out = machine.succeed(
            "curl -sSf -o /dev/null -H 'Accept-Encoding: gzip' "
            "-w '%{content_type}|%header{content-encoding}' "
            f"http://127.0.0.1/test.{ext}"
        )
        content_type, _, encoding = out.partition("|")
        return content_type.strip(), encoding.strip()

    with subtest("compressible types are gzipped"):
        for ext in ${builtins.toJSON compressible}:
            content_type, encoding = probe(ext)
            assert encoding == "gzip", (
                f".{ext} is served as {content_type} but came back uncompressed "
                f"(content-encoding: {encoding}); is that type in compressMimeTypes?"
            )

    with subtest("already compressed types are served verbatim"):
        for ext in ${builtins.toJSON incompressible}:
            content_type, encoding = probe(ext)
            assert encoding == "", (
                f".{ext} is served as {content_type} and should not be recompressed, "
                f"but content-encoding was {encoding}"
            )
  '';
}
