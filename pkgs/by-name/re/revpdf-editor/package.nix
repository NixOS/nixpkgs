# /etc/nixos/pkgs/revpdf-editor/default.nix
{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 {
  pname = "revpdf-editor";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/Pawandeep-prog/revpdf-release/raw/refs/heads/main/linux/revpdf_editor-x86_64.AppImage";
    sha256 = "sha256-s9po8Ml2guA3e70aTvT/A2wlCTKyB8lkxGOVfFjSh/s=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      libepoxy
      gtk3
      glib
      gdk-pixbuf
      libGL
    ];

  meta = with lib; {
    description = "PDF editor";
    homepage = "https://revpdf.com";
    license = licenses.unfree; # o la licenza corretta
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ e1618033 ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
