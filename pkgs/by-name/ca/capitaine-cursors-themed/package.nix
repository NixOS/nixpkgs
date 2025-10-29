{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "capitaine-cursors-themed";
  version = "5";

  src = fetchzip {
    url = "https://github.com/sainnhe/capitaine-cursors/releases/download/r${version}/Linux.zip";
    stripRoot = false;
    hash = "sha256-ipPpmZKU/xLA45fdOvxVbtFDCUsCYIvzeps/DjhFkNg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ./ $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Fork of the capitaine cursor theme, with some additional variants (Gruvbox, Nord, Palenight) and support for HiDPI";
    homepage = "https://github.com/sainnhe/capitaine-cursors";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.math-42 ];
  };
}
