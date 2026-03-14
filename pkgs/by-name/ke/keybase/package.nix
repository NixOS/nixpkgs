{
  replaceVars,
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
}:

buildGoModule (finalAttrs: {
  pname = "keybase";
  version = "6.6.0";

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
    hash = "sha256-ZIOS4plCF7coSRLSk86v4xMxRS1geKpRDwZJ9Ouys1Q=";
  };
  vendorHash = "sha256-PP60BF2C71zLlbR1obtqVRvt7eKp7IB9atF2BKJD9Zs=";

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
