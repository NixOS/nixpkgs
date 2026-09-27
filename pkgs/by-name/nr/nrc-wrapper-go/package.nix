{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "nrc-wrapper-go";
  version = "1.3.8-2";

  src = fetchFromGitHub {
    owner = "technicfan";
    repo = "nrc-wrapper-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LNLnh3Vnr4OKIXbTg5HgOKopkchKP8XS/eTw2tBe20I=";
  };

  vendorHash = "sha256-PvwvVavGTV5QGprMn1M2SOq6upaYCzyzM6dNvZzlXo4=";

  postInstall = ''
    mv $out/bin/main $out/bin/nrc-wrapper
  '';

  meta = {
    description = "NoRisk-Client wrapper for 3rd-Party Minecraft launchers written in go";
    homepage = "https://github.com/technicfan/nrc-wrapper-go/tree/main";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "nrc-wrapper";
    maintainers = with lib.maintainers; [ mzntori ];
  };
})
