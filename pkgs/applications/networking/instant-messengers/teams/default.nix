{ stdenv, fetchurl, makeDesktopItem, wrapGAppsHook
, alsaLib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype, libgnome-keyring
, gdk-pixbuf, glib, gtk3, libnotify, libX11, libXcomposite, libXcursor, libXdamage, libuuid, libsecret, libxkbfile
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, pulseaudio, dpkg, tree, autoPatchelfHook }:

let
  binaryName = "teams";
in stdenv.mkDerivation rec {
  pname = "teams";
  version = "1.2.00.32451";

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
    sha256 = "1p053kg5qksr78v2h7cxia5mb9kzgfwm6n99x579vfx48kka1n18";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook autoPatchelfHook ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  dontWrapGApps = true;

  buildInputs = [
    libcxx systemd pulseaudio libsecret libxkbfile libgnome-keyring
    stdenv.cc.cc alsaLib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
   ];

  installPhase = ''
    mkdir -p $out
    cp -r usr/bin $out/bin
    cp -r usr/share $out/share

    #mkdir -p $out/{bin,opt/${binaryName},share/pixmaps}
    #mv * $out/opt/${binaryName}

    #chmod +x $out/opt/${binaryName}/${binaryName}
    #patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
    #    $out/opt/${binaryName}/${binaryName}

    wrapProgram $out/share/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \

    #ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    #ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png

    #ln -s "${desktopItem}/share/applications" $out/share/
  '';

  runtimeDependencies = [ pulseaudio ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "teams";
    icon = pname;
    desktopName = "Teams";
    genericName = meta.description;
    categories = "Network;InstantMessaging;";
  };

  meta = with stdenv.lib; {
    description = "Unified communication and collaboration platform";
    homepage = "https://teams.microsoft.com/start";
    downloadPage = "https://teams.microsoft.com/downloads";
    license = licenses.unfree;
    maintainers = with maintainers; [ jonringer ];
    platforms = [ "x86_64-linux" ];
  };
}
