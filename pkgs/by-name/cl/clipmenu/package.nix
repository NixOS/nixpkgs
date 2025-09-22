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
stdenv.mkDerivation rec {
  pname = "clipmenu";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "clipmenu";
    rev = version;
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

  meta = with lib; {
    description = "Clipboard management using dmenu";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.publicDomain;
  };
}
