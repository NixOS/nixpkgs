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
  version = "9.7.37";
  versionItems = builtins.splitVersion version;
  versionString = (builtins.elemAt versionItems 0) + (builtins.elemAt versionItems 1);

  src = let
    base = "https://www.hamrick.com/files/";
  in {
    x86_64-darwin = fetchurl {
      url = "${base}/vuex64${versionString}.dmg";
      sha256 = "1zimcnmyfdqgnc6n1rl8929sill7wfhmvxyfs1q1brmhqyg73fz2";
    };
    i686-darwin = fetchurl {
      url = "${base}/vuex32${versionString}.dmg";
      sha256 = "0dja8krncm107mxgkvdfligyn2mabkwi501n8b80iqsdh96zrbzf";
    };
    x86_64-linux = fetchurl {
      url = "${base}/vuex64${versionString}.tgz";
      sha256 = "175ns9x23vgb2ib8d8fm0iy8vaym31rkkylaghscc7hn0qix5iyy";
    };
    i686-linux = fetchurl {
      url = "${base}/vuex32${versionString}.tgz";
      sha256 = "06lq5bqwnfnwnb4g4k0zkzli6hqd2fl9ciyqjvpwym982brsyp31";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vuea64${versionString}.tgz";
      sha256 = "1vv97ipb8ps6hlihjcxwh1hamz0yb4vlz59fra6zjkq1vn389m2k";
    };
    armv6l-linux = fetchurl {
      url = "${base}/vuea32${versionString}.tgz";
      sha256 = "06s2zsh47g9wzbnqfgs5qiabpc275x56ks26p3x9ja5mfgkv3yma";
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
