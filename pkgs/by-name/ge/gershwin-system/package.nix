{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "gershwin-system";
  version = "0-unstable-2026-08-19";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gershwin-desktop";
    repo = "gershwin-system";
    rev = "a29ac743fea4388d580467e1998d7bf4c06b1de2";
    hash = "sha256-T/1iGevtrkIfoUVDu645UTujd+lhUxOuGiYfCYlaCYw=";
  };

  dontBuild = true;

  env.DESTDIR = placeholder "out";

  meta = {
    homepage = "https://github.com/gershwin-desktop/gershwin-system";
    description = "Gershwin Desktop configuration defaults and scaffolding files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
}
