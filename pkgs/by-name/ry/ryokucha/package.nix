{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ryokucha";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "ryokucha";
    rev = finalAttrs.version;
    hash = "sha256-imKZSbNZHKIbLtD9E0D+AaKTvGSz8u2/2dJR0cpn/fo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [ gtk4 ];

  strictDeps = true;

  meta = {
    description = "GTK4 library that includes customized widgets";
    homepage = "https://github.com/ryonakano/ryokucha";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
