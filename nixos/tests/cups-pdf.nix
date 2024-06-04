import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "cups-pdf";

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ];
    environment.systemPackages = [ pkgs.poppler_utils ];
    fonts.packages = [ pkgs.dejavu_fonts ];  # yields more OCR-able pdf
    services.printing.cups-pdf.enable = true;
    services.printing.cups-pdf.instances = {
      opt = {};
      noopt.installPrinter = false;
    };
    hardware.printers.ensurePrinters = [{
      name = "noopt";
      model = "CUPS-PDF_noopt.ppd";
      deviceUri = "cups-pdf:/noopt";
    }];
  };

  # we cannot check the files with pdftotext, due to
  # https://github.com/alexivkin/CUPS-PDF-to-PDF/issues/7
  # we need `imagemagickBig` as it has ghostscript support

  testScript = ''
    from subprocess import run
    machine.wait_for_unit("multi-user.target")
    for name in ("opt", "noopt"):
        text = f"test text {name}".upper()
        machine.wait_until_succeeds(f"lpstat -v {name}")
        machine.succeed(f"su - alice -c 'echo -e \"\n  {text}\" | lp -d {name}'")
        # wait until the pdf files are completely produced and readable by alice
        machine.wait_until_succeeds(f"su - alice -c 'pdfinfo /var/spool/cups-pdf-{name}/users/alice/*.pdf'")
        machine.succeed(f"cp /var/spool/cups-pdf-{name}/users/alice/*.pdf /tmp/{name}.pdf")
        machine.copy_from_vm(f"/tmp/{name}.pdf", "")
        run(f"${pkgs.imagemagickBig}/bin/convert -density 300 $out/{name}.pdf $out/{name}.jpeg", shell=True, check=True)
        assert text.encode() in run(f"${lib.getExe pkgs.tesseract} $out/{name}.jpeg stdout", shell=True, check=True, capture_output=True).stdout
  '';

  meta.maintainers = [ lib.maintainers.yarny ];
})
