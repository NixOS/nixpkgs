{ stdenv
, fetchurl
, gnutar
, autoPatchelfHook
, glibc
, gtk2
, xorg
, libgudev
, undmg
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "vuescan";

  # Minor versions are released using the same file name
  version = "9.7";
  versionString = builtins.replaceStrings ["."] [""] version;

  src = let
    base = "https://www.hamrick.com/files/";
  in {
    x86_64-darwin = fetchurl {
      url = "${base}/vuex64${versionString}.dmg";
      sha256 = "045ihd2pj0zmzjfwn2qmv5114yvs9vf6mw6sf4x3hwcdmpk40sfh";
    };
    i686-darwin = fetchurl {
      url = "${base}/vuex32${versionString}.dmg";
      sha256 = "0nny1jm3s1nr7xm03mcy3zgxvslznnvc8a5gn93gjww6gwg9rcn6";
    };
    x86_64-linux = fetchurl {
      url = "${base}/vuex64${versionString}.tgz";
      sha256 = "0jkj92w3y66dcxwq3kkg7vhqxljwf9dqs563xbkh1r7piyjfwycm";
    };
    i686-linux = fetchurl {
      url = "${base}/vuex32${versionString}.tgz";
      sha256 = "03qac9c0sg21jwz91nzzwk3ml8byv06ay9wiq00dl62nmhs20r5m";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vuea64${versionString}.tgz";
      sha256 = "17viy7kcb78j0p3ik99psabmkgpwpmgvk96wjhn9aar48gpyr1wj";
    };
    armv6l-linux = fetchurl {
      url = "${base}/vuea32${versionString}.tgz";
      sha256 = "0m7sp18bdf2l2yf3q3z6c3i0bm4mq2h4ndm6qfvyknip0h11gv7i";
    };
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Scanner software supporting a wide range of devices";
    homepage = "https://hamrick.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ evax ];
    platforms = [
      "x86_64-darwin" "i686-darwin"
      "x86_64-linux" "i686-linux"
      "aarch64-linux" "armv6l-linux"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    # Stripping the binary breaks the license form
    dontStrip = true;

    nativeBuildInputs = [
      gnutar
      autoPatchelfHook
    ];

    buildInputs = [
      glibc
      gtk2
      xorg.libSM
      libgudev
    ];

    unpackPhase = ''
      tar xfz $src
    '';

    installPhase = ''
      install -m755 -D VueScan/vuescan $out/bin/vuescan
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = {
      x86_64-darwin = "vuex64${versionString}.dmg";
      i686-darwin = "vuex32${versionString}.dmg";
    }.${system} or throwSystem;

    installPhase = ''
      mkdir -p $out/Applications/VueScan.app
      cp -R . $out/Applications/VueScan.app
    '';
  };
in if stdenv.isDarwin
  then darwin
  else linux
