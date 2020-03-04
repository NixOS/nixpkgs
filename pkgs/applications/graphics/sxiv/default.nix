{ stdenv, fetchFromGitHub, libXft, imlib2, giflib, libexif, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "sxiv";
  version = "26";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xaawlfdy7b277m38mgg4423kd7p1ffn0dq4hciqs6ivbb3q9c4f";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ libXft imlib2 giflib libexif ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dt $out/share/applications sxiv.desktop
  '';

  meta = {
    description = "Simple X Image Viewer";
    homepage = https://github.com/muennich/sxiv;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
