{
 stdenv,
 appimage-run,
 fetchurl,
 runtimeShell,
 gsettings-desktop-schemas,
 gtk3,
 gobject-introspection,
 wrapGAppsHook,
}:

stdenv.mkDerivation rec {
  # latest version that runs without errors
  # https://github.com/ssbc/patchwork/issues/972
  version = "3.11.4";
  pname = "patchwork";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/Patchwork-${version}-linux-x86_64.AppImage";
    sha256 = "1blsprpkvm0ws9b96gb36f0rbf8f5jgmw4x6dsb1kswr4ysf591s";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ appimage-run gtk3 gsettings-desktop-schemas gobject-introspection ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/${pname}
    echo "#!${runtimeShell}" > $out/bin/${pname}
    echo "${appimage-run}/bin/appimage-run $out/share/${pname}" >> $out/bin/${pname}
    chmod +x $out/bin/${pname} $out/share/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt (SSB).";
    longDescription = ''
      sea-slang for gossip - a scuttlebutt is basically a watercooler on a ship.
    '';
    homepage = https://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ thedavidmeister ];
    platforms = [ "x86_64-linux" ];
  };
}
