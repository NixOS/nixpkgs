{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitea,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libHX";
  version = "5.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    tag = "v${finalAttrs.version}";
    owner = "jengelh";
    repo = "libhx";
    hash = "sha256-z1/D5dkcDc2VIoGCvunUYsLGq3AV6jZ01Edf1vuUx9o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://inai.de/projects/libhx/";
=======
  fetchurl,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "libHX";
  version = "3.22";

  src = fetchurl {
    url = "mirror://sourceforge/libhx/libHX/${version}/${pname}-${version}.tar.xz";
    sha256 = "18w39j528lyg2026dr11f2xxxphy91cg870nx182wbd8cjlqf86c";
  };

  patches = [ ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = ''
    sh autogen.sh
  '';

  meta = with lib; {
    homepage = "https://libhx.sourceforge.net/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      libHX is a C library (with some C++ bindings available) that provides data structures
      and functions commonly needed, such as maps, deques, linked lists, string formatting
      and autoresizing, option and config file parsing, type checking casts and more.
    '';
<<<<<<< HEAD
    changelog = "https://codeberg.org/jengelh/libhx/src/branch/master/doc/changelog.rst";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3
      lgpl21Plus
      mit
    ];
  };
})
=======
    maintainers = [ ];
    platforms = platforms.linux;
    license = with licenses; [
      gpl3
      lgpl21Plus
      wtfpl
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
