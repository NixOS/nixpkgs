{
  stdenv,
  lib,
  fetchFromGitHub,
  gtk-engine-murrine,
}:

stdenv.mkDerivation rec {
  pname = "flat-remix-gtk";
  version = "20240730";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    sha256 = "sha256-EWe84bLG14RkCNbHp0S5FbUQ5/Ye/KbCk3gPTsGg9oQ=";
  };

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with lib; {
    description = "GTK application theme inspired by material design";
    homepage = "https://drasite.com/flat-remix-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.mkg20001 ];
  };
}
