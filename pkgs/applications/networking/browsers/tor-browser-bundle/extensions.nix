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
    pname = "https-everywhere";
    version = "2017.10.4";

    extid = "https-everywhere-eff@eff.org";

    src = fetchgit {
      url = "https://git.torproject.org/https-everywhere.git";
      rev = "refs/tags/${version}";
      sha256 = "1g7971xygnhagnb25xjdf6mli6091ai9igx42d0ww88g8i0cqfzj";
      fetchSubmodules = true; # for translations, TODO: remove
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
    pname = "noscript";
    version = "5.1.2";

    extid = "{73a6fe31-595d-460b-a920-fcc0f8843232}";

    src = fetchurl {
      url = "https://secure.informaction.com/download/releases/noscript-${version}.xpi";
      sha256 = "1fzspdiwhjabwz1yxb3gzj7giz9jbc1xxm65i93rvhzcp537cs42";
    };

    dontUnpack = true;

    installPhase = ''
      install -m 444 -D $src "$out/$extid.xpi"
    '';
  };

  torbutton = stdenv.mkDerivation rec {
    pname = "torbutton";
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
    pname = "tor-launcher";
    version = "0.2.13";

    extid = "tor-launcher@torproject.org";

    src = fetchgit {
      url = "https://git.torproject.org/tor-launcher.git";
      rev = "refs/tags/${version}";
      sha256 = "1f98v88y2clwvjiw77kxqc9cacp5h0489a540nc2wmsx7vnskrq0";
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
