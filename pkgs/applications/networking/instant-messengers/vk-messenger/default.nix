{ stdenv, fetchurl, rpmextract, autoPatchelfHook
, xorg, gtk3, gnome2, nss, alsaLib, udev, libnotify
, wrapGAppsHook }:

let
  version = "4.5.2";
in stdenv.mkDerivation {
  pname = "vk-messenger";
  inherit version;
  src = {
    i686-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.i686.rpm";
      sha256 = "11xsdmvd2diq3m61si87x2c08nap0vakcypm90wjmdjwayg3fdlw";
    };
    x86_64-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.x86_64.rpm";
      sha256 = "0j65d6mwj6rxczi0p9fsr6jh37jxw3a3h6w67xwgdvibb7lf3gbb";
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
