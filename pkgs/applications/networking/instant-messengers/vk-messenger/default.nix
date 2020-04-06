{ stdenv, fetchurl, rpmextract, autoPatchelfHook
, xorg, gtk3, gnome2, nss, alsaLib, udev, libnotify
, wrapGAppsHook }:

let
  version = "5.0.1";
in stdenv.mkDerivation {
  pname = "vk-messenger";
  inherit version;
  src = {
    i686-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.i686.rpm";
      sha256 = "1ji23x13lzbkiqfrrwx1pj6gmms0p58cjmjc0y4g16kqhlxl60v6";
    };
    x86_64-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.x86_64.rpm";
      sha256 = "01vvmia2qrxvrvavk9hkkyvfg4pg15m01grwb28884vy4nqw400y";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  nativeBuildInputs = [ rpmextract autoPatchelfHook wrapGAppsHook ];
  buildInputs = (with xorg; [
    libXdamage libXtst libXScrnSaver libxkbfile
  ]) ++ [
    gtk3 nss alsaLib
  ];
  runtimeDependencies = [ udev.lib libnotify ];

  unpackPhase = ''
    rpmextract $src
  '';

  buildPhase = ''
    substituteInPlace usr/share/applications/vk.desktop \
      --replace /usr/share/pixmaps/vk.png vk
  '';

  installPhase = ''
    mkdir $out
    cd usr
    cp -r --parents bin $out
    cp -r --parents share/vk $out
    cp -r --parents share/applications $out
    cp -r --parents share/pixmaps $out
  '';

  meta = with stdenv.lib; {
    description = "Simple and Convenient Messaging App for VK";
    homepage = https://vk.com/messenger;
    license = licenses.unfree;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["i686-linux" "x86_64-linux"];
  };
}
