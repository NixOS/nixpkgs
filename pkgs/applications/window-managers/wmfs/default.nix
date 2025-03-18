{ lib, stdenv, fetchFromGitHub, fetchpatch,
  libX11, libXinerama, libXrandr, libXpm, libXft, imlib2 }:
stdenv.mkDerivation {
  pname = "wmfs";

  version = "201902";

  src = fetchFromGitHub {
    owner = "xorg62";
    repo = "wmfs";
    sha256 = "1m7dsmmlhq2qipim659cp9aqlriz1cwrrgspl8baa5pncln0gd5c";
    rev = "b7b8ff812d28c79cb22a73db2739989996fdc6c2";
  };

  patches = [
    # Pull patch pending upstream inclusion to fix build on
    # -fno-common toolchain like upstream gcc-10:
    #  https://github.com/xorg62/wmfs/pull/104
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/xorg62/wmfs/commit/e4ec12618f4689d791892ebb49df9610a25d24d3.patch";
      sha256 = "0qvwry9sikvr85anzha9x4gcx0r2ckwdxqw2in2l6bl9z9d9c0w2";
    })
  ];

  buildInputs = [
    imlib2
    libX11
    libXinerama
    libXrandr
    libXpm
    libXft
  ];

  preConfigure = "substituteInPlace configure --replace '-lxft' '-lXft'";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "XDG_CONFIG_DIR=${placeholder "out"}/etc/xdg"
    "MANPREFIX=${placeholder "out"}/share/man"
  ];

  meta = with lib; {
    description = "Window manager from scratch";
    license = licenses.bsd2;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.linux;
    mainProgram = "wmfs";
  };
}
