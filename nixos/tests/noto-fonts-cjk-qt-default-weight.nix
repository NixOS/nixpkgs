import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "noto-fonts-cjk-qt";
  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine = {
    imports = [ ./common/x11.nix ];
    fonts = {
      enableDefaultFonts = false;
      fonts = [ pkgs.noto-fonts-cjk-sans ];
    };
  };

  testScript =
    let
      script = pkgs.writers.writePython3 "qt-default-weight" {
        libraries = [ pkgs.python3Packages.pyqt6 ];
      } ''
        from PyQt6.QtWidgets import QApplication
        from PyQt6.QtGui import QFont, QRawFont

        app = QApplication([])
        f = QRawFont.fromFont(QFont("Noto Sans CJK SC", 20))

        assert f.styleName() == "Regular", f.styleName()
      '';
    in ''
      machine.wait_for_x()
      machine.succeed("${script}")
    '';
})
