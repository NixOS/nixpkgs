{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edlin";
  version = "2.24";

  src =
    let
      inherit (finalAttrs) version;
    in
    fetchurl {
      url = "mirror://sourceforge/freedos-edlin/freedos-edlin/${version}/edlin-${version}.tar.bz2";
      hash = "sha256-zj5kCDdEkjzDiun/5xL8yX2SVsnZc3hrzIAYUo4Vj+c=";
    };

  postInstall = ''
    mkdir -p $out/share/doc/edlin-${finalAttrs.version}/
    cp AUTHORS ChangeLog README TODO edlin.html $out/share/doc/edlin-${finalAttrs.version}/
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/freedos-edlin/";
    description = "FreeDOS line editor";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    mainProgram = "edlin";
  };
})
