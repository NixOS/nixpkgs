{
  lib,
  stdenv,
  callPackage,
  unrarSupport ? false,
}:

let
  pname = "calibre";

  version = "7.23.0";

  meta = with lib; {
    homepage = "https://calibre-ebook.com";
    description = "Comprehensive e-book software";
    longDescription = ''
      calibre is a powerful and easy to use e-book manager. Users say it’s
      outstanding and a must-have. It’ll allow you to do nearly everything and
      it takes things a step beyond normal e-book software. It’s also completely
      free and open source and great for both casual users and computer experts.
    '';
    changelog = "https://github.com/kovidgoyal/calibre/releases/tag/v${version}";
    license = if unrarSupport then licenses.unfreeRedistributable else licenses.gpl3Plus;
    maintainers = with maintainers; [
      pSub
      noghartt
    ];
    platforms = platforms.unix ++ platforms.darwin;
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
