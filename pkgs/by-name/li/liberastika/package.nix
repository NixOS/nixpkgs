{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "liberastika";
  version = "1.1.5";

  src = fetchzip {
    url = "mirror://sourceforge/project/lib-ka/liberastika-ttf-${version}.zip";
    stripRoot = false;
    hash = "sha256-woUpOmxhj6eEw7PKJ8EyRcs3ORj0gCZhxHP5a5dy5z0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Liberation Sans fork with improved cyrillic support";
    homepage = "https://sourceforge.net/projects/lib-ka/";

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
