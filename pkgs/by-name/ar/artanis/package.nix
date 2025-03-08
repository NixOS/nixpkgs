{
  lib,
  stdenv,
  fetchFromGitLab,
  guile,
  texinfo,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "artanis";
  version = "1.2.2";

  src = fetchFromGitLab {
    owner = "hardenedlinux";
    repo = "artanis";
    tag = "v${version}";
    hash = "sha256-exCnQ0YDjRmG4hptwHI++2DLyfivl2JcxvL/xY3E6kw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
    pkg-config
  ];

  buildInputs = [
    guile
  ];

  doCheck = true;

  meta = {
    description = "Fast monolithic Scheme web framework";
    homepage = "https://artanis.dev/";
    downloadPage = "https://gitlab.com/hardenedlinux/artanis";
    license = with lib.licenses; [ gpl3Plus lgpl3Plus];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.all;
  };
}

