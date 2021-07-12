{ stdenv, lib, fetchurl, rpmextract, undmg, autoPatchelfHook
, xorg, gtk3, gnome2, nss, alsa-lib, udev, libnotify
, wrapGAppsHook }:

let
  pname = "vk-messenger";
  version = "5.2.3";

  src = {
    i686-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.i686.rpm";
      sha256 = "09zi2rzsank6lhw1z9yar1rp634y6qskvr2i0rvqg2fij7cy6w19";
    };
    x86_64-linux = fetchurl {
      url = "https://desktop.userapi.com/rpm/master/vk-${version}.x86_64.rpm";
      sha256 = "1m6saanpv1k5wc5s58jpf0wsgjsj7haabx8nycm1fjyhky1chirb";
    };
    x86_64-darwin = fetchurl {
      url = "https://web.archive.org/web/20210310071550/https://desktop.userapi.com/mac/master/vk.dmg";
      sha256 = "0j5qsr0fyl55d0x46xm4h2ykwr4y9z1dsllhqx5lnc15nc051s9b";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Simple and Convenient Messaging App for VK";
    homepage = "https://vk.com/messenger";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
  };

  linux = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ rpmextract autoPatchelfHook wrapGAppsHook ];
    buildInputs = (with xorg; [
      libXdamage libXtst libXScrnSaver libxkbfile
    ]) ++ [ gtk3 nss alsa-lib ];

    runtimeDependencies = [ (lib.getLib udev) libnotify ];

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
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };
in if stdenv.isDarwin then darwin else linux
