{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  intltool,
  pkg-config,
  gtk3,
  SDL2,
  xorg,
  wrapGAppsHook3,
  libcdio,
  nasm,
  ffmpeg_4,
  file,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "pcsxr";
  version = "1.9.94";

  # codeplex does not support direct downloading
  src = fetchurl {
    url = "mirror://debian/pool/main/p/pcsxr/pcsxr_${version}.orig.tar.xz";
    sha256 = "0q7nj0z687lmss7sgr93ij6my4dmhkm2nhjvlwx48dn2lxl6ndla";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/01_fix-i386-exec-stack.patch";
      sha256 = "17497wjxd6b92bj458s2769d9bpp68ydbvmfs9gp51yhnq4zl81x";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/02_disable-ppc-auto-dynarec.patch";
      sha256 = "0v8n79z034w6cqdrzhgd9fkdpri42mzvkdjm19x4asz94gg2i2kf";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/03_fix-plugin-dir.patch";
      sha256 = "0vkl0mv6whqaz79kvvvlmlmjpynyq4lh352j3bbxcr0vjqffxvsy";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/04_update-homedir-symlinks.patch";
      sha256 = "18r6n025ybr8fljfsaqm4ap31wp8838j73lrsffi49fkis60dp4j";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/05_format-security.patch";
      sha256 = "03m4kfc9bk5669hf7ji1anild08diliapx634f9cigyxh72jcvni";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/06_warnings.patch";
      sha256 = "0iz3g9ihnhisfgrzma9l74y4lhh57na9h41bmiam1millb796g71";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/07_non-linux-ip-addr.patch";
      sha256 = "14vb9l0l4nzxcymhjjs4q57nmsncmby9qpdr7c19rly5wavm4k77";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/pcsxr/raw/315e56d16e36ef3011f72d0fe86190728d2ba596/debian/patches/08_reproducible.patch";
      sha256 = "1cx9q59drsk9h6l31097lg4aanaj93ysdz5p88pg9c7wvxk1qz06";
    })

    ./uncompress2.patch
    ./0001-libpcsxcore-fix-build-with-ffmpeg-4.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    SDL2
    xorg.libXv
    xorg.libXtst
    libcdio
    nasm
    ffmpeg_4
    file
    xorg.libXxf86vm
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: AboutDlg.o:/build/pcsxr/gui/Linux.h:42: multiple definition of `cfgfile';
  #     LnxMain.o:/build/pcsxr/gui/Linux.h:42: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  dynarecTarget =
    if stdenv.isx86_64 then
      "x86_64"
    else if stdenv.isi686 then
      "x86"
    else
      "no"; # debian patch 2 says ppc doesn't work

  configureFlags = [
    "--enable-opengl"
    "--enable-ccdda"
    "--enable-libcdio"
    "--enable-dynarec=${dynarecTarget}"
  ];

  postInstall = ''
    mkdir -p "$out/share/doc/${pname}-${version}"
    cp README \
       AUTHORS \
       doc/keys.txt \
       doc/tweaks.txt \
       ChangeLog.df \
       ChangeLog \
       "$out/share/doc/${pname}-${version}"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Playstation 1 emulator";
    homepage = "https://github.com/iCatButler/pcsxr";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "pcsxr";
  };
}
