{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edlin";
  version = "2.21";

  src =
    let
      inherit (finalAttrs) version;
    in
    fetchurl {
      url = "mirror://sourceforge/freedos-edlin/freedos-edlin/${version}/edlin-${version}.tar.bz2";
      hash = "sha256-lQ/tw8dvEKV81k5GV05o49glOmfYcEeJBmgPUmL3S2I=";
    };

  postInstall = ''
    mkdir -p $out/share/doc/edlin-${finalAttrs.version}/
    cp AUTHORS ChangeLog README TODO edlin.htm $out/share/doc/edlin-${finalAttrs.version}/
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/freedos-edlin/";
    description = "FreeDOS line editor";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
    mainProgram = "edlin";
  };
})
