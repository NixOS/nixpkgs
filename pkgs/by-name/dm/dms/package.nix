{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dms";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "anacrolix";
    repo = "dms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WeilPG0eOarwFxp67/ebvyFu/99DmDoSg6llE/3Fz+0=";
  };

  vendorHash = "sha256-kzdh2xlUQCFA9cCixy8h2WkbhDTW5PHxnAKEJwcgkOE=";

  meta = {
    homepage = "https://github.com/anacrolix/dms";
    description = "UPnP DLNA Digital Media Server with basic video transcoding";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.claes ];
    platforms = lib.platforms.linux;
    mainProgram = "dms";
  };
})
