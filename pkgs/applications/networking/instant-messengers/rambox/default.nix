{ stdenv, fetchurl, dpkg, makeWrapper
, xorg, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  version = "0.5.12";

  runtimeDeps = [
    udev libnotify
  ];
  deps = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver libxcb
  ]) ++ [
    gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ] ++ runtimeDeps;
in stdenv.mkDerivation rec {
  name = "rambox-${version}";
  src = fetchurl {
    url = "https://github.com/saenzramiro/rambox/releases/download/${version}/Rambox_${version}-${bits}.deb";
    sha256 = if bits == "x64" then
      "1jlvpq7wryz4vf6xlsb9c38jrhjiv18rdf2ndlv76png60wl8418" else
      "063j3gcpp18wdvspy7d43cgv7i5v8c42hn2zpp083jixw9ddsqwa";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" opt/Rambox/rambox
    patchelf --set-rpath "$out/opt/Rambox:${stdenv.lib.makeLibraryPath deps}" opt/Rambox/rambox

    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Rambox/rambox $out/bin

    # provide resources
    cp -r usr/share $out
    substituteInPlace $out/share/applications/rambox.desktop \
      --replace Exec=\"/opt/Rambox/rambox\" Exec=rambox
  '';

  postFixup = ''
    paxmark m $out/opt/Rambox/rambox
    wrapProgram $out/opt/Rambox/rambox --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = http://rambox.pro;
    license = licenses.mit;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
