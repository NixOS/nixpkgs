{ lib, stdenv, imagemagick }:

stdenv.mkDerivation {
  pname = "euclid-icon-theme";
  version = "1.0";

  src = ../../assets/branding;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    mkdir -p $out/share/icons/Euclid-3D/scalable/apps

    # Generate requested sizes
    for size in 16 22 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/Euclid-3D/''${size}x''${size}/apps
      magick euclid-linux-3d-logo.png -resize ''${size}x''${size} $out/share/icons/Euclid-3D/''${size}x''${size}/apps/euclid-linux-3d.png
    done

    # Generate the scalable SVG directly (just copy or embed)
    cp euclid-linux-3d-logo.png $out/share/icons/Euclid-3D/scalable/apps/euclid-linux-3d.png

    # Aliases
    for icon in euclid-welcome euclid-installer euclid-settings euclid-terminal euclid-files euclid-software euclid-help euclid-about euclid-session-budgie-wayfire start-here system-logo distributor-logo; do
      for size in 16 22 24 32 48 64 128 256 512; do
        ln -s euclid-linux-3d.png $out/share/icons/Euclid-3D/''${size}x''${size}/apps/$icon.png
      done
      ln -s euclid-linux-3d.png $out/share/icons/Euclid-3D/scalable/apps/$icon.png
    done

    cat << 'INDEX' > $out/share/icons/Euclid-3D/index.theme
[Icon Theme]
Name=Euclid-3D
Comment=Euclid Linux 3D Icon Theme
Inherits=hicolor,Qogir,Adwaita
Directories=16x16/apps,22x22/apps,24x24/apps,32x32/apps,48x48/apps,64x64/apps,128x128/apps,256x256/apps,512x512/apps,scalable/apps

[16x16/apps]
Size=16
Type=Fixed

[22x22/apps]
Size=22
Type=Fixed

[24x24/apps]
Size=24
Type=Fixed

[32x32/apps]
Size=32
Type=Fixed

[48x48/apps]
Size=48
Type=Fixed

[64x64/apps]
Size=64
Type=Fixed

[128x128/apps]
Size=128
Type=Fixed

[256x256/apps]
Size=256
Type=Fixed

[512x512/apps]
Size=512
Type=Fixed

[scalable/apps]
Size=512
Type=Scalable
MinSize=16
MaxSize=512
INDEX
  '';

  meta = {
    description = "Euclid Linux 3D Icon Theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
