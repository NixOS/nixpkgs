{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "mynewt-newt";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings [ "." ] [ "_" ] version}_tag";
    sha256 = "sha256-HWZDs4kYWveEqzPRNGNbghc1Yg6hy/Pq3eU5jW8WdHc=";
  };

  vendorHash = "sha256-/LK+NSs7YZkw6TRvBQcn6/SszIwAfXN0rt2AKSBV7CE=";

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
