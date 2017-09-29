{ stdenv
, fetchgit
, fetchurl

# common
, zip

# HTTPS Everywhere
, git
, libxml2 # xmllint
, python27
, python27Packages
, rsync
}:

{
  https-everywhere = stdenv.mkDerivation rec {
    name = "https-everywhere-${version}";
    version = "5.2.21";

    extid = "https-everywhere-eff@eff.org";

    src = fetchgit {
      url = "https://git.torproject.org/https-everywhere.git";
      rev = "refs/tags/${version}";
      sha256 = "0z9madihh4b4z4blvfmh6w1hsv8afyi0x7b243nciq9r4w55xgfa";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      git
      libxml2 # xmllint
      python27
      python27Packages.lxml
      rsync
      zip
    ];

    buildPhase = ''
      $shell ./makexpi.sh ${version} --no-recurse
    '';

    installPhase = ''
      install -m 444 -D pkg/https-everywhere-$version-eff.xpi "$out/$extid.xpi"
    '';
  };

  noscript = stdenv.mkDerivation rec {
    name = "noscript-${version}";
    version = "5.0.10";

    extid = "{73a6fe31-595d-460b-a920-fcc0f8843232}";

    src = fetchurl {
      url = "https://secure.informaction.com/download/releases/noscript-${version}.xpi";
      sha256 = "18k5karbaj5mhd9cyjbqgik6044bw88rjalkh6anjanxbn503j6g";
    };

    unpackPhase = ":";

    installPhase = ''
      install -m 444 -D $src "$out/$extid.xpi"
    '';
  };

  torbutton = stdenv.mkDerivation rec {
    name = "torbutton-${version}";
    version = "1.9.8.1";

    extid = "torbutton@torproject.org";

    src = fetchgit {
      url = "https://git.torproject.org/torbutton.git";
      rev = "refs/tags/${version}";
      sha256 = "1amp0c9ky0a7fsa0bcbi6n6ginw7s2g3an4rj7kvc1lxmrcsm65l";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      $shell ./makexpi.sh
    '';

    installPhase = ''
      install -m 444 -D pkg/torbutton-$version.xpi "$out/$extid.xpi"
    '';
  };

  tor-launcher = stdenv.mkDerivation rec {
    name = "tor-launcher-${version}";
    version = "0.2.12.3";

    extid = "tor-launcher@torproject.org";

    src = fetchgit {
      url = "https://git.torproject.org/tor-launcher.git";
      rev = "refs/tags/${version}";
      sha256 = "0126x48pjiy2zm4l8jzhk70w24hviaz560ffp4lb9x0ar615bc9q";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      make package
    '';

    installPhase = ''
      install -m 444 -D pkg/tor-launcher-$version.xpi "$out/$extid.xpi"
    '';
  };
}
