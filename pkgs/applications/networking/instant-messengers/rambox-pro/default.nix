{ autoPatchelfHook, fetchurl, makeWrapper, nodePackages.asar, nss, stdenv, xorg.libxkbfile }:

rambox-pro = stdenv.mkDerivation rec {
  name = "rambox-pro-${version}";
  version = "1.1.2";

  dontBuild = true;
  dontStrip = true;

  buildInputs = [ nss xorg.libxkbfile ];
  nativeBuildInputs = [ autoPatchelfHook nodePackages.asar makeWrapper ];

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/RamboxPro-${version}-linux-x64.tar.gz";
    sha256 = "0rrfpl371hp278b02b9b6745ax29yrdfmxrmkxv6d158jzlv0dlr";
  };

  patches = [ ./remove-bash-args.patch ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/RamboxPro $out/share/applications
    asar e resources/app.asar $out/opt/RamboxPro/resources/app.asar.unpacked   
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  postFixup = ''
    makeWrapper ${pkgs.electron}/lib/electron/.electron-wrapped $out/bin/ramboxpro \
      --add-flags "$out/opt/RamboxPro/resources/app.asar.unpacked --without-update" \
      --prefix PATH : ${pkgs.xdg_utils}/bin
  '';

  desktopItem = makeDesktopItem {
    name = "rambox-pro";
    exec = "ramboxpro";
    type = "Application";
    desktopName = "Rambox Pro";
  };

  meta = with stdenv.lib; {
    description = "Messaging and emailing app that combines common web applications into one";
    homepage = http://rambox.pro;
    license = licenses.unfree;
    maintainers = with maintainers; [ chrisaw ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
