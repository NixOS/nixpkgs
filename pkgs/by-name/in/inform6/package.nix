{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inform6";
  version = "6.44-r7";

  src = fetchurl {
    url = "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-${finalAttrs.version}.tar.gz";
    hash = "sha256-Ph+U5ccm9fWc8IZ1bcFOZqP9KB3brHXq1hHUWqV+S9s=";
  };

  buildInputs = [ perl ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Interactive fiction compiler and libraries";
    longDescription = ''
      Inform 6 is a C-like programming language for writing interactive fiction
      (text adventure) games.
    '';
    homepage = "https://gitlab.com/DavidGriffith/inform6unix";
    changelog = "https://gitlab.com/DavidGriffith/inform6unix/-/raw/${finalAttrs.version}/NEWS";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ ddelabru ];
    platforms = lib.platforms.all;
  };
})
