{
  replaceVars,
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
}:

buildGoModule (finalAttrs: {
  pname = "keybase";
  version = "6.6.3";

  modRoot = "go";
  subPackages = [
    "kbnm"
    "keybase"
  ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TRDJINzuObgn6JWZ9CoHWxKO23I9sceDlB4MmnqlOvw=";
  };
  vendorHash = "sha256-OGavtp0vYqK0D4P+ypVyEF8GsvDvfIDQXsjlKmpKJJ4=";

  patches = [
    (replaceVars ./fix-paths-keybase.patch {
      gpg = "${gnupg}/bin/gpg";
      gpg2 = "${gnupg}/bin/gpg2";
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
