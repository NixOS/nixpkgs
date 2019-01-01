{ stdenv, makeWrapper, appimage-run, fetchurl }:

let
  version = "3.11.4";

  plat = {
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "x86_64-linux" = "1blsprpkvm0ws9b96gb36f0rbf8f5jgmw4x6dsb1kswr4ysf591s";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation rec {
  name = "patchwork-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/patchwork-${version}-linux-${plat}.AppImage";
    inherit sha256;
  };

  buildInputs = [ makeWrapper appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/patchwork.AppImage
    chmod +x $out/share/patchwork.AppImage

    ln -s ${appimage-run}/bin/appimage-run $out/bin/patchwork
    wrapProgram $out/bin/patchwork \
        --add-flags $out/share/patchwork.AppImage
  '';

  meta = with stdenv.lib; {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt";
    homepage = http://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
}
