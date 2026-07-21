{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  clipnotify,
  coreutils,
  gawk,
  util-linux,
  xdotool,
  xsel,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clipmenu";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "clipmenu";
    rev = finalAttrs.version;
    sha256 = "sha256-nvctEwyho6kl4+NXi76jT2kG7nchmI2a7mgxlgjXA5A=";
  };

  postPatch = ''
    sed -i init/clipmenud.service \
      -e "s,/usr/bin,$out/bin,"
  '';

  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [
    makeWrapper
    xsel
    clipnotify
  ];

  postFixup = ''
    sed -i "$out/bin/clipctl" -e 's,clipmenud\$,\.clipmenud-wrapped\$,'

    wrapProgram "$out/bin/clipmenu" \
      --prefix PATH : "${lib.makeBinPath [ xsel ]}"

    wrapProgram "$out/bin/clipmenud" \
      --set PATH "${
        lib.makeBinPath [
          clipnotify
          coreutils
          gawk
          util-linux
          xdotool
          xsel
        ]
      }"
  '';

  meta = {
    description = "Clipboard management using dmenu";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = with lib.maintainers; [ jb55 ];
    license = lib.licenses.publicDomain;
  };
})
