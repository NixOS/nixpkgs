{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "karla";
  version = "2.004";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "karla";
    rev = "69b25f663101efb4113dd7ed416c120dd2dce56a";
    hash = "sha256-9zf2gfhSn8Aly8a2CINsNXZPRfVcaxFE9In4Qqx3Fn4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype fonts/ttf/*.ttf
    install -Dm444 -t $out/share/fonts/variable fonts/variable/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Outstanding grotesque sans serif typeface family";
    longDescription = ''
      Karla is an outstanding grotesque sans serif typeface
      family created by Jonathan Pinhorn (a graduate of the
      MA in Typeface Design at the University of Reading),
      released through Google Webfonts in 2012.
    '';
    homepage = "https://github.com/googlefonts/karla";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mimvoid ];
  };
}
