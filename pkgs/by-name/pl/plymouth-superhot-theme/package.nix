{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-superhot-theme";
  version = "0.1.0-unstable-2025-05-01";

  src = fetchFromGitHub {
    owner = "m0tholith";
    repo = "plymouth-superhot-theme";
    rev = "f81175cecaf76e3da112ffae7dcccd9261c2768c";
    hash = "sha256-ZNk6VxbULDFAxfyWceHKhFQTeJW4LkGgxTBD3CvUgoM=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/superhot
    cp * $out/share/plymouth/themes/superhot
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';

  meta = {
    description = "A plymouth theme that displays the SUPERHOT loading screen.";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ m0tholith ];
  };
}
