{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mononoki";
  version = "1.6";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
    stripRoot = false;
    hash = "sha256-HQM9rzIJXLOScPEXZu0MzRlblLfbVVNJ+YvpONxXuwQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/mononoki
    cp * $out/share/fonts/mononoki

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/madmalik/mononoki";
    description = "Font for programming and code review";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
