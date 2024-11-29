{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  pulseaudio,
}:
mkKdeDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${version}.tar.xz";
    hash = "sha256-8hvzDy/z5nDSBG+WYGncI/XmU/9Wus24kgwTdCZMvB4=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ pulseaudio ];

  meta.license = with lib.licenses; [
    lgpl21Only
    lgpl3Only
  ];
}
