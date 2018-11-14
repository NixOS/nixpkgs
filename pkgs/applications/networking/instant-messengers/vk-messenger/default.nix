{ stdenv, fetchurl, rpmextract, autoPatchelfHook
, xorg, gtk2, gnome2, nss, alsaLib, udev, libnotify }:

let
  version = "3.9.0";
in stdenv.mkDerivation {
  name = "vk-messenger-${version}";
  src = {
    i686-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.i686.rpm";
      sha256 = "150qjj6ccbdp3gxs99jbzp27in1y8qkngn7jgb9za61pm4j70va3";
    };
    x86_64-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.x86_64.rpm";
      sha256 = "04lavv614qhj17zccpdih4k6ghj21nd0s8qxbkxkqb1jb0z8dfz9";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  nativeBuildInputs = [ rpmextract autoPatchelfHook ];
  buildInputs = (with xorg; [
    libXdamage libXtst libXScrnSaver libxkbfile
  ]) ++ [
    gtk2 gnome2.GConf nss alsaLib
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
    hydraPlatforms = [];
  };
}
