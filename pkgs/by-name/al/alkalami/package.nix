{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "alkalami";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/alkalami/Alkalami-${version}.zip";
    hash = "sha256-ra664VbUKc8XpULCWhLMVnc1mW4pqZvbvwuBvRQRhcY=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    mkdir -p $out/share/doc/alkalami
    mv *.txt documentation $out/share/doc/alkalami
  '';

  meta = {
    homepage = "https://software.sil.org/alkalami/";
    description = "Font for Arabic-based writing systems in the Kano region of Nigeria and in Niger";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
  };
}
