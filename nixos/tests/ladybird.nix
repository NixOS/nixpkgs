{ pkgs, ... }:
{
  name = "ladybird";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      fgaz
      schembriaiden
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      services.xserver.enable = true;
      hardware.graphics.enable = true;
      programs.ladybird.enable = true;
      environment.systemPackages = [
        pkgs.groff
        pkgs.groff.perl
      ];
      environment.etc."ladybird-webgl-test.html".text = ''
        <!DOCTYPE html>
        <meta charset="utf-8">
        <h1 id="status">Waiting for WebGL</h1>
        <canvas id="canvas" width="8" height="8"></canvas>
        <script>
          const status = document.getElementById("status");
          const gl = document.getElementById("canvas").getContext("webgl");
          if (gl) {
            gl.clearColor(1, 0, 0, 1);
            gl.clear(gl.COLOR_BUFFER_BIT);
            const pixel = new Uint8Array(4);
            gl.readPixels(0, 0, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, pixel);
            status.textContent = pixel.join(",") === "255,0,0,255"
              ? "WebGL rendering works" : "Unexpected WebGL pixel: " + pixel.join(",");
          } else {
            status.textContent = "WebGL context unavailable";
          }
        </script>
      '';
    };

  enableOCR = true;

  testScript = ''
    from datetime import timedelta

    machine.wait_for_x()
    machine.succeed("echo '<!DOCTYPE html><html><body><h1>Hello world</h1></body></html>' > page.html")
    machine.execute("Ladybird file://$(pwd)/page.html >&2 &")
    machine.wait_for_window("Ladybird")
    # On first launch, the welcome tab is selected before the requested page.
    machine.wait_for_text("Welcome to Ladybird")
    machine.send_key("ctrl-tab")
    machine.wait_for_text("Hello world")
    machine.screenshot("screen")

    # Check that the PDF.js viewer renders the document, not just its toolbar.
    machine.succeed("printf '.ps 32\\n.sp 1i\\nPDF rendering works\\n' | SOURCE_DATE_EPOCH=1 groff -Tpdf > /tmp/ladybird-test.pdf")
    machine.send_key("ctrl-l")
    machine.send_chars("file:///tmp/ladybird-test.pdf\n")
    machine.wait_for_text("PDF rendering works")
    machine.screenshot("pdf")

    with subtest("Render and read back a WebGL pixel with the sandbox enabled"):
        machine.send_key("ctrl-l")
        machine.send_chars("file:///etc/ladybird-webgl-test.html\n")
        machine.wait_for_text("WebGL rendering works", timeout=timedelta(seconds=60))
        machine.screenshot("webgl")
  '';
}
