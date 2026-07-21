{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblqr-1";
  version = "0.4.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "carlobaldassi";
    repo = "liblqr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RN58r9AUceziWfZBqyAjjPXrdfilR6cxn3FzQxiQEdE=";
  };

  # Fix build with gcc15
  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ glib ];

  meta = {
    homepage = "http://liblqr.wikidot.com";
    description = "Seam-carving C/C++ library called Liquid Rescaling";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl3
      lgpl3
    ];
  };
})
