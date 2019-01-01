{ stdenv, makeWrapper, appimage-run, fetchurl }:

let
  version = "7.15.6";

  plat = {
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "x86_64-linux" = "14za07sxfgi7ixjbqrgwfx2rcxwlgi98k5bwn434aqy55rxvmlqb";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation rec {
  name = "patchbay-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchbay/releases/download/v${version}/patchbay-linux-${version}-${plat}.AppImage";
    inherit sha256;
  };

  buildInputs = [ makeWrapper appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/patchbay.AppImage
    chmod +x $out/share/patchbay.AppImage

    ln -s ${appimage-run}/bin/appimage-run $out/bin/patchbay
    wrapProgram $out/bin/patchbay \
        --add-flags $out/share/patchbay.AppImage
  '';

  meta = with stdenv.lib; {
    description = "An alternative Secure Scuttlebutt client interface that is fully compatible with Patchwork";
    longDescription = ''
        Patchbay is a scuttlebutt client designed to be easy to modify
        and extend. It uses the same database as Patchwork and
        Patchfoo, so you can easily take it for a spin with your
        existing identity.
    '';
    homepage = http://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
}
