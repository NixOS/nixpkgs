{
  stdenv,
  lib,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  pkg-config,
  glib,
  libgee,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "caroline";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dcharles525";
    repo = "caroline";
    rev = version;
    hash = "sha256-v423h9EC/h6B9VABhkvmYcyYXKPpvqhI8O7ZjbO637k";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    libgee
    gtk3
  ];

  meta = with lib; {
    description = "Simple Cairo Chart Library for GTK and Vala";
    homepage = "https://github.com/dcharles525/Caroline";
    maintainers = with maintainers; [ grindhold ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
