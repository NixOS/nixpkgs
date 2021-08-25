{ stdenv, fetchurl, makeWrapper
, pkg-config
, ncurses, libX11
, util-linux, file, which, groff

  # adds support for handling removable media (vifm-media). Linux only!
, mediaSupport ? false, python3 ? null, udisks2 ? null, lib ? null
}:

let isFullPackage = mediaSupport;
in stdenv.mkDerivation rec {
  pname = if isFullPackage then "vifm-full" else "vifm";
  version = "0.11";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "0rqyd424y0g5b5basw2ybb60r9gar4f40d1xgzr3c2dsy4jpwvyh";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ ncurses libX11 util-linux file which groff ];

  postFixup = let
    path = lib.makeBinPath
      [ udisks2
        (python3.withPackages (p: [p.dbus-python]))
      ];

    wrapVifmMedia = "wrapProgram $out/share/vifm/vifm-media --prefix PATH : ${path}";
  in ''
    ${if mediaSupport then wrapVifmMedia else ""}
  '';

  meta = with lib; {
    description = "A vi-like file manager${if isFullPackage then "; Includes support for optional features" else ""}";
    maintainers = with maintainers; [ raskin ];
    platforms = if mediaSupport then platforms.linux else platforms.unix;
    license = licenses.gpl2;
    downloadPage = "https://vifm.info/downloads.shtml";
    homepage = "https://vifm.info/";
    updateWalker = true;
    changelog = "https://github.com/vifm/vifm/blob/v${version}/ChangeLog";
  };
}
