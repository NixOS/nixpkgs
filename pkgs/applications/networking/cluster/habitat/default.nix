{ stdenv, lib, fetchurl, fetchzip }:

let

  version = "0.7.0";

  linux = rec {
    timestamp = "20160614230104";
    src = fetchurl {
      url = "https://dl.bintray.com/habitat/stable/linux/x86_64/hab-${version}-${timestamp}-x86_64-linux.tar.gz";
      sha256 = "1xaclcswvqxwvrxxjv2kabx6v14bp2pwi514gvrvs90sv5ysxh87";
    };
  };

  darwin = rec {
    timestamp = "20160614231131";
    src = fetchzip {
      url = "https://dl.bintray.com/habitat/stable/darwin/x86_64/hab-${version}-${timestamp}-x86_64-darwin.zip";
      sha256 = "1v158a38qch7ax6yxsdd1n89z6gb6fsaj776v11y4i8p7yhcc3a9";
    };
  };

in stdenv.mkDerivation rec {
  inherit version;

  name = "habitat-${version}";

  src = if stdenv.isDarwin then darwin.src else linux.src;

  installPhase =
    ''
      mkdir -p $out/bin
      cp -v hab $out/bin
    '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
