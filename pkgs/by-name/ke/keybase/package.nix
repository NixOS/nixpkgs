{
  replaceVars,
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
}:

buildGoModule (finalAttrs: {
  pname = "keybase";
  version = "6.6.2";

  modRoot = "go";
  subPackages = [
    "kbnm"
    "keybase"
  ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-biekmiPgEI4tq6b45+3YeNFfCDPePz5MFowjmXG6HmI=";
  };
  vendorHash = "sha256-PI1VK1CWkCQhEwn6ExjerQhbph/J89NKAe1nSazAd1g=";

  patches = [
    (replaceVars ./fix-paths-keybase.patch {
      gpg = lib.getExe gnupg;
      gpg2 = lib.getExe' gnupg "gpg2";
    })
  ];
  tags = [ "production" ];
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://www.keybase.io/";
    description = "Keybase official command-line utility and service";
    mainProgram = "keybase";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      avaq
      np
      rvolosatovs
      shofius
      ryand56
    ];
    license = lib.licenses.bsd3;
  };
})
