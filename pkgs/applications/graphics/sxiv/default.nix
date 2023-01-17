{ lib, stdenv, fetchFromGitHub, libXft, imlib2, giflib, libexif, conf ? null }:

stdenv.mkDerivation rec {
  pname = "sxiv";
  version = "26";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xaawlfdy7b277m38mgg4423kd7p1ffn0dq4hciqs6ivbb3q9c4f";
  };

  configFile = lib.optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = lib.optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ libXft imlib2 giflib libexif ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dt $out/share/applications sxiv.desktop
  '';

  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jfrankenau ];
  };
}
