{ pkgs, stdenv, lib, fetchurl, dpkg, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "dyalog";
  version = "18.2.45405";

  src = fetchurl {
    url = "https://download.dyalog.com/download.php?file=${lib.versions.majorMinor version}/linux_64_${version}_unicode.x86_64.deb";
    sha256 = "sha256-pA/WGTA6YvwG4MgqbiPBLKSKPtLGQM7BzK6Bmyz5pmM=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    alsa-lib
    nspr
    ncurses5
    nss
    gtk2
    gtk3
    unixODBC
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv
    xorg.libXScrnSaver
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/opt $out/usr $out/bin

    cp -a usr/share/* $out/share
    cp -a opt/* $out/opt

    ln -s $out/opt/mdyalog/${lib.versions.majorMinor version}/64/unicode/dyalog $out/bin/dyalog
    ln -s $out/opt/mdyalog/${lib.versions.majorMinor version}/64/unicode/mapl $out/bin/mapl
  '';

  meta = with lib; {
    homepage = "https://www.dyalog.com/";
    description= "Dyalog APL interpreter";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fwam ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.dyalog;
  };
}
