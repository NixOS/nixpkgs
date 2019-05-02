{ stdenv, appimage-run, fetchurl, runtimeShell, gsettings-desktop-schemas, gtk3, gobject-introspection, wrapGAppsHook, nodePackages }:

let
  version = "3.11.6";
in

stdenv.mkDerivation rec {
  name = "patchwork-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/Patchwork-${version}-linux-x86_64.AppImage";
    sha256 = "1d2rq6l2mbi6bqv8321ps5bi9n8aqriwv7agc2zvgylm0cxyc4cq";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ appimage-run gtk3 gsettings-desktop-schemas gobject-introspection nodePackages.git-ssb ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/patchwork.AppImage
    echo "#!${runtimeShell}" > $out/bin/patchwork
    echo "${appimage-run}/bin/appimage-run $out/share/patchwork.AppImage" >> $out/bin/patchwork
    chmod +x $out/bin/patchwork $out/share/patchwork.AppImage
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
