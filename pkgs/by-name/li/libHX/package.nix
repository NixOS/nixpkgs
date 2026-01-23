{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libHX";
  version = "5.2";

  src = fetchFromCodeberg {
    tag = "v${finalAttrs.version}";
    owner = "jengelh";
    repo = "libhx";
    hash = "sha256-z1/D5dkcDc2VIoGCvunUYsLGq3AV6jZ01Edf1vuUx9o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://inai.de/projects/libhx/";
    longDescription = ''
      libHX is a C library (with some C++ bindings available) that provides data structures
      and functions commonly needed, such as maps, deques, linked lists, string formatting
      and autoresizing, option and config file parsing, type checking casts and more.
    '';
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
