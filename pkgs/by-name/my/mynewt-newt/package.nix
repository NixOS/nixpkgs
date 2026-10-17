{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "mynewt-newt";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings [ "." ] [ "_" ] version}_tag";
    sha256 = "sha256-LHknQC9exvt11qLDvHGangXUVdq5WUHQwm4X9p/yAzA=";
  };

  vendorHash = "sha256-xv2z22YFbeQeek6IQkhGp+3AqYjmbKDszVHqvEGD9XY=";

  doCheck = false;

  meta = {
    homepage = "https://mynewt.apache.org/";
    description = "Build and package management tool for embedded development";
    longDescription = ''
      Apache Newt is a smart build and package management tool,
      designed for C and C++ applications in embedded contexts. Newt
      was developed as a part of the Apache Mynewt Operating System.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
