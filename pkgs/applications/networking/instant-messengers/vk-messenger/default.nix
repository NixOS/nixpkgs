{
  stdenv,
  lib,
  fetchurl,
  rpmextract,
  undmg,
  autoPatchelfHook,
  xorg,
  gtk3,
  nss,
  alsa-lib,
  udev,
  libnotify,
  wrapGAppsHook3,
}:

let
  pname = "vk-messenger";
  version = "5.3.2";

  src =
    {
      i686-linux = fetchurl {
        url = "https://desktop.userapi.com/rpm/master/vk-${version}.i686.rpm";
        sha256 = "L0nE0zW4LP8udcE8uPy+cH9lLuQsUSq7cF13Gv7w2rI=";
      };
      x86_64-linux = fetchurl {
        url = "https://desktop.userapi.com/rpm/master/vk-${version}.x86_64.rpm";
        sha256 = "spDw9cfDSlIuCwOqREsqXC19tx62TiAz9fjIS9lYjSQ=";
      };
      x86_64-darwin = fetchurl {
        url = "https://web.archive.org/web/20220302083827/https://desktop.userapi.com/mac/master/vk.dmg";
        sha256 = "hxK8I9sF6njfCxSs1KBCHfnG81JGKUgHKAeFLtuCNe0=";
      };
    }
    .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Simple and Convenient Messaging App for VK";
    homepage = "https://vk.com/messenger";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      rpmextract
      autoPatchelfHook
      wrapGAppsHook3
    ];
    buildInputs =
      (with xorg; [
        libXdamage
        libXtst
        libXScrnSaver
        libxkbfile
      ])
      ++ [
        gtk3
        nss
        alsa-lib
      ];

    runtimeDependencies = [
      (lib.getLib udev)
      libnotify
    ];

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
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };
in
if stdenv.isDarwin then darwin else linux
