{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    hash = "sha256-WIgcHuZgAOrlg+WyOS4TyzWziNzjyQB2sPDM9fR6kwA=";
    rev = "v${version}";
  };

  makeFlags = [
    "PREFIX=$(out)"
    # By default install in $(PREFIX)/share/libretro/info
    # that is not in RetroArch's core info path
    "INSTALLDIR=$(PREFIX)/share/retroarch/cores"
  ];

  dontBuild = true;

  meta = with lib; {
    description = "Libretro's core info files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
