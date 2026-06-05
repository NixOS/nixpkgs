{
  stdenv,
  lib,
  fetchFromGitHub,
  gtk-engine-murrine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flat-remix-gtk";
  version = "20240730";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "flat-remix-gtk";
    rev = finalAttrs.version;
    sha256 = "sha256-EWe84bLG14RkCNbHp0S5FbUQ5/Ye/KbCk3gPTsGg9oQ=";
  };

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = {
    description = "GTK application theme inspired by material design";
    homepage = "https://drasite.com/flat-remix-gtk";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.mkg20001 ];
  };
})
