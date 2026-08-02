{ lib, stdenv }:

stdenv.mkDerivation {
  pname = "euclid-icon-theme";
  version = "1.0";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/icons/Euclid-3D/scalable/apps
    # Generate requested icons dynamically
    for icon in euclid-linux-3d euclid-welcome euclid-installer euclid-settings euclid-terminal euclid-files euclid-software euclid-help euclid-about euclid-session-lumina euclid-session-mate euclid-session-plasma; do
      cat << 'SVG' > $out/share/icons/Euclid-3D/scalable/apps/$icon.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <rect width="100" height="100" fill="#FF0000" rx="15"/>
  <circle cx="50" cy="50" r="30" fill="#FFFF00"/>
  <path d="M 50 20 L 80 80 L 20 80 Z" fill="#FFFFFF"/>
</svg>
SVG
    done

    cat << 'INDEX' > $out/share/icons/Euclid-3D/index.theme
[Icon Theme]
Name=Euclid 3D
Comment=Euclid Linux 3D Icon Theme
Inherits=hicolor,Adwaita
Directories=scalable/apps

[scalable/apps]
Size=48
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
