{ stdenv, lib, fetchurl, xdg_utils, dpkg, makeWrapper, autoPatchelfHook
, libXtst, libXScrnSaver, gtk3, nss, alsaLib, udev, libnotify, wrapGAppsHook
}:

let
  version = "0.7.7";
in stdenv.mkDerivation rec {
  pname = "rambox";
  inherit version;
  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-amd64.deb";
      sha256 = "0bij4f1bkg94gc8pq7r6yfym5zcvwc2ymdnmnmh5m4h1pa1gk6x9";
    };
    i686-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-i386.deb";
      sha256 = "1nhgqjha10jvyf9nsghvlkibg7byj8qz140639ygag9qlpd51rfs";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook wrapGAppsHook ];
  buildInputs = [ libXtst libXScrnSaver gtk3 nss alsaLib ];
  runtimeDependencies = [ (lib.getLib udev) libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Rambox/rambox $out/bin

    # provide resources
    cp -r usr/share $out
    substituteInPlace $out/share/applications/rambox.desktop \
      --replace Exec=/opt/Rambox/rambox Exec=rambox
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${xdg_utils}/bin
    )
  '';

  meta = with stdenv.lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.mit;
    maintainers = with maintainers; [ gnidorah ma27 ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
