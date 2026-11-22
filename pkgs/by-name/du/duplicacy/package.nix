{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "duplicacy";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    hash = "sha256-WxCbKIgGKDughloRWXGqj/IPKVOhpFmYOjJyoiEb6Yk=";
  };

  vendorHash = "sha256-PxzwISwBGUte4cyCMxmL1K0iuHvutC51uBo2PX91kWA=";

  doCheck = false;

  meta = {
    homepage = "https://duplicacy.com";
    description = "New generation cloud backup tool";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ffinkdevs
      devusb
    ];
  };
}
