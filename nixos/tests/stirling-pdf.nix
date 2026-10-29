{ lib, pkgs, ... }:
let
  port = 18083;
  fixture =
    pkgs.runCommand "stirling-pdf-synthetic.pdf"
      {
        nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.reportlab ])) ];
      }
      ''
        python - <<'PY'
        import os

        from reportlab.pdfgen import canvas

        pdf = canvas.Canvas(os.environ["out"])
        pdf.setFont("Helvetica", 12)
        pdf.drawString(72, 720, "PUBLIC WORDS")
        pdf.drawString(72, 690, "REMOVE ME 12345")
        pdf.save()
        PY
      '';
in
{
  name = "stirling-pdf";
  meta.maintainers = with lib.maintainers; [ timhae ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.stirling-pdf = {
        enable = true;
        package = pkgs.stirling-pdf-free;
        environment = {
          SERVER_ADDRESS = "127.0.0.1";
          SERVER_PORT = port;
          SECURITY_ENABLELOGIN = false;
          SYSTEM_ENABLEANALYTICS = false;
        };
      };
      environment.etc."stirling-test.pdf".source = fixture;
      environment.systemPackages = [
        pkgs.curl
        pkgs.poppler-utils
      ];
      virtualisation.memorySize = 2048;
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("stirling-pdf.service")
    machine.wait_until_succeeds(
        "curl -fsS http://127.0.0.1:${toString port}/api/v1/info/status | grep -q '${pkgs.stirling-pdf-free.version}'"
    )
    machine.succeed("test $(stat -c %a /run/stirling-pdf) = 700")
    machine.succeed("test $(stat -c %a /var/lib/private/stirling-pdf) = 700")
    machine.succeed("curl -fsS http://127.0.0.1:${toString port}/ | grep -q '<html'")
    machine.succeed("pdftotext /etc/stirling-test.pdf - | grep -q 'REMOVE ME 12345'")

    # Native redaction should remove target text while retaining other text.
    machine.succeed(
        "curl -fsS -X POST http://127.0.0.1:${toString port}/api/v1/security/auto-redact "
        "-F fileInput=@/etc/stirling-test.pdf -F 'listOfText=REMOVE ME 12345' "
        "-F useRegex=false -F wholeWordSearch=false -F redactColor=000000 "
        "-F customPadding=0.1 -F convertPDFToImage=false -o /tmp/native-redacted.pdf"
    )
    machine.succeed("pdftotext /tmp/native-redacted.pdf - | grep -q 'PUBLIC WORDS'")
    machine.succeed("! pdftotext /tmp/native-redacted.pdf - | grep -q 'REMOVE ME 12345'")

    # Image conversion provides a safer export when native redaction cannot be verified.
    machine.succeed(
        "curl -fsS -X POST http://127.0.0.1:${toString port}/api/v1/security/auto-redact "
        "-F fileInput=@/etc/stirling-test.pdf -F 'listOfText=REMOVE ME 12345' "
        "-F useRegex=false -F wholeWordSearch=false -F redactColor=000000 "
        "-F customPadding=0.1 -F convertPDFToImage=true -o /tmp/image-redacted.pdf"
    )
    machine.succeed("pdfinfo /tmp/image-redacted.pdf | grep -q 'Pages:.*1'")
    machine.succeed("! pdftotext /tmp/image-redacted.pdf - | grep -q 'REMOVE ME 12345'")
  '';
}
