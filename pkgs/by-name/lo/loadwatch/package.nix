{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loadwatch";
  version = "1.1-1-g6d2544c";

  src = fetchgit {
    url = "https://git.sr.ht/~woffs/loadwatch";
    hash = "sha256-K7H0lUL1suU0hOyJx8fxL9YQ23WUWt2i1WZ5uLkvHK4=";
    rev = "6d2544c0caaa8a64bbafc3f851e06b8056c30e6e";
  };

  patches = [
    # autoheader fails when template is not defined
    ./missing-kstat-template-autoheader.patch
    # implicit <string.h> not allowed in c99 mode
    ./fix-c99-failure.patch
  ];

  nativeBuildInputs = [
    # conftest program uses main() with implicit return type
    autoreconfHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    install loadwatch lw-ctl $out/bin
  '';

  meta = {
    description = "Run a program using only idle cycles";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.all;
  };
})
