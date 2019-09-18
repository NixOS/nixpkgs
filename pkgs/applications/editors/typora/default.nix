{ stdenv, fetchurl
, dpkg, atomEnv, makeWrapper, wrapGAppsHook, autoPatchelfHook
, glib, gtk3, gsettings-desktop-schemas
, systemd, fontconfig
, withPandoc ? false, pandoc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.73";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "1fgcb4bx5pw8ah5j30d38gw7qi1cmqarfhvgdns9f2n0d57bvvw3";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook

    atomEnv.packages
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    {
      cd usr
      mv share/typora $out/lib
      mv share/{doc,icons,applications} $out/share/
    }

    ln -sT $out/lib/typora/Typora $out/bin/typora

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${makeLibraryPath [ systemd fontconfig stdenv.cc.cc ]})
    ${optionalString withPandoc ''gappsWrapperArgs+=(--prefix PATH : "${pandoc}/bin")''} \
  '';

  meta = {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin worldofpeace ];
    platforms = [ "x86_64-linux" ];
  };
}
