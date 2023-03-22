{ stdenv, fetchurl, makeWrapper
, perl # used to generate help tags
, pkg-config
, ncurses, libX11
, util-linux, file, which, groff

  # adds support for handling removable media (vifm-media). Linux only!
, mediaSupport ? false, python3 ? null, udisks2 ? null, lib ? null
}:

let isFullPackage = mediaSupport;
in stdenv.mkDerivation rec {
  pname = if isFullPackage then "vifm-full" else "vifm";
  version = "0.12.1";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "sha256-j+KBPr3Mz+ma7OArBdYqIJkVJdRrDM+67Dr2FMZlVog=";
  };

  nativeBuildInputs = [ perl pkg-config makeWrapper ];
  buildInputs = [ ncurses libX11 util-linux file which groff ];

  postPatch = ''
    # Avoid '#!/usr/bin/env perl' reverences to build help.
    patchShebangs --build src/helpztags
  '';

  postFixup = let
    path = lib.makeBinPath
      [ udisks2
        (python3.withPackages (p: [p.dbus-python]))
      ];

    wrapVifmMedia = "wrapProgram $out/share/vifm/vifm-media --prefix PATH : ${path}";
  in ''
    ${lib.optionalString mediaSupport wrapVifmMedia}
  '';

  meta = with lib; {
    description = "A vi-like file manager${lib.optionalString isFullPackage "; Includes support for optional features"}";
    maintainers = with maintainers; [ raskin ];
    platforms = if mediaSupport then platforms.linux else platforms.unix;
    license = licenses.gpl2;
    downloadPage = "https://vifm.info/downloads.shtml";
    homepage = "https://vifm.info/";
    changelog = "https://github.com/vifm/vifm/blob/v${version}/ChangeLog";
  };
}
