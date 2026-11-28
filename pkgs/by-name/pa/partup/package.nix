{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  libyaml,
  mount,
  parted,
  pkg-config,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "partup";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "phytec";
    repo = "partup";
    tag = "v${version}";
    hash = "sha256-O5xMZt02lV27+hufjvra5eHd6YjjCebhl0fXvGuDgmc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    libyaml
    mount
    parted.dev
    util-linux

  ];

  # because they messed up their source code
  NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  strictDeps = true;

  meta = with lib; {
    description = "System initialization program formatting and writing flash devices";
    homepage = "https://github.com/phytec/partup";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      matthiasbeyer
      hemera
    ];
  };
}
