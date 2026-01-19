{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "100";
in
stdenvNoCC.mkDerivation {
  pname = "seshat";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/seshat_${majorVersion}${minorVersion}.zip";
    hash = "sha256-XgprDhzAbcTzZw2QOwpCnzusYheYmSlM+ApU+Y0wO2Q=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://dotcolon.net/font/seshat/";
    description = "Roman body font designed for main text by Sora Sagano";
    longDescription = ''
      Seshat is a Roman body font designed for the main text. By
      referring to the classical balance, we changed some lines by
      omitting part of the lines such as "A" and "n".

      Also, by attaching the strength of the thickness like Optima
      to the main drawing, it makes it more sharp design.

      It incorporates symbols and ligatures used in the European region.
    '';
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.cc0;
  };
}
