{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  unzip,
  pkg-config,
  python3,
  SDL2,
  SDL2_image,
  enet,
  freetype,
  glpk,
  intltool,
  libpng,
  libunibreak,
  libvorbis,
  libwebp,
  libxml2,
  luajit,
  meson,
  ninja,
  openal,
  openblas,
  pcre2,
  physfs,
  suitesparse,
  libyaml,
  cmark,
  dbus,
}:

let
  lyaml = fetchFromGitHub {
    owner = "gvvaughan";
    repo = "lyaml";
    tag = "v6.2.8";
    hash = "sha256-ADLXi38sAs9ifQ4HJoYzgdp/dw0axGmVCtqJjpqWcmQ=";
  };
  nativefiledialog-extended = fetchFromGitHub {
    owner = "btzy";
    repo = "nativefiledialog-extended";
    tag = "v1.2.1";
    hash = "sha256-GwT42lMZAAKSJpUJE6MYOpSLKUD5o9nSe9lcsoeXgJY=";
  };
  nativefiledialog-extended-patch = fetchurl {
    url = "https://wrapdb.mesonbuild.com/v2/nativefiledialog-extended_1.2.1-1/get_patch";
    hash = "sha256-BEouiB2HTVWokrYc9VOqdnjRwPBs+us5obQ/NMqXawk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "naev";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "naev";
    repo = "naev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Phes5d7q1PgviwKFcvDvm9xregcbj2NTTPdmbaXJ19Y=";
    fetchSubmodules = true;
  };

  buildInputs = [
    SDL2
    SDL2_image
    enet
    freetype
    glpk
    libpng
    libunibreak
    libvorbis
    libwebp
    libxml2
    luajit
    openal
    openblas
    pcre2
    physfs
    suitesparse
    libyaml
    cmark
    dbus
  ];

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pyyaml
        mutagen
      ]
    ))
    meson
    ninja
    pkg-config
    intltool
    unzip
  ];

  mesonFlags = [
    "-Ddocs_c=disabled"
    "-Ddocs_lua=disabled"
    "-Dluajit=enabled"
  ];

  postPatch = ''
    patchShebangs --build dat/outfits/bioship/generate.py utils/build/*.py utils/*.py dat/naevpedia/ships/ships.py dat/naevpedia/outfits/outfits.py

    # Add a missing include to fix the build against luajit-2.1.1741730670.
    # Otherwise the build fails as:
    #   src/lutf8lib.c:421:22: error: 'INT_MAX' undeclared (first use in this function)
    # TODO: drop after 0.12.3 release
    sed -i '1i#include <limits.h>' src/lutf8lib.c
    cp -r ${lyaml} subprojects/lyaml-6.2.8
    chmod -R +w subprojects/lyaml-6.2.8
    cp -r subprojects/packagefiles/lyaml/* subprojects/lyaml-6.2.8
    cp -r ${nativefiledialog-extended} subprojects/nativefiledialog-extended-1.2.1
    chmod -R +w subprojects/nativefiledialog-extended-1.2.1
    tmp=$(mktemp -d)
    unzip ${nativefiledialog-extended-patch} -d $tmp
    cp -r $tmp/*/* subprojects/nativefiledialog-extended-1.2.1
  '';

  meta = {
    description = "2D action/rpg space game";
    mainProgram = "naev";
    homepage = "http://www.naev.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ralismark ];
    platforms = lib.platforms.linux;
  };
})
