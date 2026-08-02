{ lib, stdenv }:

stdenv.mkDerivation {
  pname = "euclid-wallpapers";
  version = "1.0";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/wallpapers/euclid-linux-3d
    cat << 'SVG' > $out/share/wallpapers/euclid-linux-3d/default.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 1080">
  <rect width="1920" height="1080" fill="#2c3e50"/>
  <circle cx="960" cy="540" r="300" fill="#e74c3c"/>
  <path d="M 960 240 L 1260 840 L 660 840 Z" fill="#f1c40f" opacity="0.8"/>
</svg>
SVG
  '';

  meta = {
    description = "Euclid Linux 3D Wallpapers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
