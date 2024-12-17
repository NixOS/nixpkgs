{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "micromdm";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "micromdm";
    repo = "micromdm";
    rev = "v${version}";
    hash = "sha256-hFoInkeJAd5h6UiF19YE9f6kkIZRmhVFVvUAkSkSqlM=";
  };

  vendorHash = "sha256-XYrv/cjma2ZYHs2x6hSXxifuS10Xa/zUx4s5O/OMLf4=";

  meta = {
    description = "Mobile Device Management server for Apple Devices, focused on giving you all the power through an API";
    homepage = "https://github.com/micromdm/micromdm";
    license = lib.licenses.mit;
    mainProgram = "micromdm";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ neverbehave ];
  };
}
