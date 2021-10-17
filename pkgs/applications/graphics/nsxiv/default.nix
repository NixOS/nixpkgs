{ lib, stdenv, fetchFromGitHub, libXft, imlib2, giflib, libexif, conf ? null }:

with lib;

stdenv.mkDerivation rec {
  pname = "nsxiv";
  version = "27.1";

  src = fetchFromGitHub {
    owner = "nsxiv";
    repo = pname;
    rev = "v${version}";
    sha256 = "1na7f0hpc9g04nm7991gzaqr5gkj08n2azx833hgxcm2w1pnn1bk";
  };

  configFile = optionalString (conf != null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf != null) "cp ${configFile} config.def.h";

  buildInputs = [ libXft imlib2 giflib libexif ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dt $out/share/applications nsxiv.desktop
  '';

  meta = with lib; {
    description = "Neo Simple X Image Viewer";
    homepage = "https://github.com/nsxiv/nsxiv";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
