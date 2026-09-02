{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  l-smash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m4acut";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = "m4acut";
    rev = "v${finalAttrs.version}";
    sha256 = "1hzf9f1fzmlpnxjaxhs2w22wzb28vd87ycaddnix1mmhvh3nvzkd";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ l-smash ];

  meta = {
    description = "Losslessly & gaplessly cut m4a (AAC in MP4) files";
    homepage = "https://github.com/nu774/m4acut";
    license = with lib.licenses; [
      bsdOriginal
      zlib
    ];
    maintainers = [ lib.maintainers.chkno ];
    platforms = lib.platforms.all;
    mainProgram = "m4acut";
  };
})
