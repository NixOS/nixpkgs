{ stdenv
, lib
, glibc
, xcbutilkeysyms
, gcc
, zlib
, libsecret
, xorg
, libcef
, libdbusmenu-gtk3
, libdbusmenu
, pcre
, jetbrains
, fetchzip
, makeDesktopItem
, makeWrapper
, runCommand
, appimageTools
, patchelf
}:
let
  pname = "jetbrains-toolbox";
  version = "1.27.3.14493";
  name = "jetbrains-toolbox";
  src = fetchzip {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
    sha256 = "sha256-aK5T95Yg8Us8vkznWlDHnPiPAKiUtlU0Eswl9rD01VY=";
    stripRoot = false;
  };
  libPath = lib.makeLibraryPath [ stdenv.cc.cc.lib glibc xorg.xcbutilkeysyms gcc zlib libsecret xorg.libXext ];
  extractApp = { name, src }: runCommand "${name}-extracted"
    {
      buildInputs = [ appimageTools.appimage-exec patchelf gcc libcef ];
    } ''
    appimage-exec.sh -x $out ${src}/${name}-${version}/${name}
    patchelf \
      --set-rpath "${libPath}:$out/jre/lib:/usr/lib64" \
      --set-interpreter ${glibc}/lib64/ld-linux-x86-64.so.2 \
      $out/jetbrains-toolbox
    patchelf --set-interpreter ${glibc}/lib64/ld-linux-x86-64.so.2 $out/glibcversion
  '';
  appimageContents = extractApp {
    inherit name src;
  };

  appimage = appimageTools.wrapAppImage {
    inherit name;
    src = appimageContents;
    extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs) ++ [ pkgs.libsecret pkgs.libcef pkgs.zlib pkgs.xorg.xcbutilkeysyms pkgs.libdbusmenu-gtk3 pkgs.libdbusmenu pkgs.pcre pkgs.jetbrains.jdk pkgs.xorg.xcbutilkeysyms pkgs.xorg.libXext ];
  };
  desktopItem = makeDesktopItem {
    name = "JetBrains Toolbox";
    exec = "jetbrains-toolbox";
    comment = "JetBrains Toolbox";
    desktopName = "JetBrains Toolbox";
    type = "Application";
    icon = "/run/current-system/sw/share/icons/${name}.svg";
    terminal = false;
    categories = [ "Development" ];
    startupWMClass = "jetbrains-toolbox";
    startupNotify = false;
  };

in
stdenv.mkDerivation {
  inherit src name appimage;

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -pv $out/share/applications
    mkdir -pv $out/share/icons
    cp -r ${appimageContents}/.DirIcon $out/share/icons/${name}.svg
    cp -r ${desktopItem}/share/applications/*  $out/share/applications/
    makeWrapper ${appimage}/bin/${name} $out/bin/${name} --append-flags "--update-failed"
  '';
  meta = with lib; {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ AnatolyPopov ];
    platforms = [ "x86_64-linux" ];
  };
}
