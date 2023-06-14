{ dpkg, stdenv, lib, fontconfig, freetype, xorg, libxkbcommon, libglvnd, makeWrapper, fetchurl }:
stdenv.mkDerivation rec {
  pname = "r-viewer";
  version = "1.0.12.b12";

  src = fetchurl {
    url = "https://www.remoteutilities.com/download/viewer1.0.12.b12.deb";
    sha256 = "b84d3ea55c25f72806db5d39eae9f7c764d9b8f70411c1d9bffdbcf5ef0fd511";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
     dpkg
     makeWrapper
  ];

  unpackCmd = "dpkg-deb -x $src .";

  dontStrip = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin/
    mv usr/share $out
    mv usr/bin $out
    rmdir usr
    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/r-viewer.desktop \
      --replace /usr/ $out/
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      fontconfig
      freetype
      xorg.libxcb
      xorg.libX11
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      libxkbcommon
      libglvnd
    ] + ":${stdenv.cc.cc.lib}/lib64";
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/r-viewer
    '';

  meta = with lib; {
    homepage = "https://www.remoteutilities.com/download/linux.php";
    description = "Remote Utilities Viewer for Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

