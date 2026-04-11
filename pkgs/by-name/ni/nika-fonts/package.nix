{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nika-fonts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "font-store";
    repo = "NikaFont";
    rev = "v${version}";
    hash = "sha256-jDemm8IyjhoCOg4Bfsp0tzUR7m+JaswL5d7Kug+asJk=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/nika-fonts {} \;

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/font-store/NikaFont/";
    description = "Persian/Arabic Open Source Font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
