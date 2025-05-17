{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
  autoPatchelfHook,
  makeWrapper,

  p11-kit,
  glibc,
  libGL,
  xorg,
}:

let
  version = "3.07.001";
  src = fetchurl {
    # The URL is taken from update check API, which is updated by the updater script.
    # The version number in this URL does not need to be interpolated string for this reason.
    # It somehow is HTTP instead of HTTPS, but should not matter because of the hash check.
    url = "http://d.updater.i4.cn/i4linux/deb/i4tools_v3.07.001.rpm";
    hash = "sha256-OJiCsAc57ympqMJ+U53Q/sZ8/PmZUpTEQWGmo4u0jj0=";
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = "i4tools";

  nativeBuildInputs = [
    rpmextract
    autoPatchelfHook
    makeWrapper
    p11-kit
  ];

  sourceRoot = src.name;
  unpackCmd = ''
    mkdir $sourceRoot && pushd $sourceRoot
    rpmextract $src
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    phome=$out/opt/i4Tools
    cp -a opt/apps/cn.i4Tools $phome

    mkdir -p $out/bin
    makeWrapper $phome/run.sh $out/bin/i4Tools \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            glibc
            libGL
          ]
          ++ (with xorg; [
            libX11
            libXext
          ])
        )
      }

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $phome/resources/logo.svg $out/share/icons/hicolor/scalable/apps/i4Tools.svg
    mkdir -p $out/share/pixmaps
    ln -s $phome/resources/logo.png $out/share/pixmaps/i4Tools.png
    mkdir -p $out/share/applications
    cp opt/apps/cn.i4Tools/cn.i4Tools.desktop $out/share/applications/i4Tools.desktop

    runHook postInstall
  '';

  postFixup = ''
    desktop=$out/share/applications/i4Tools.desktop
    sed -i "/Version=.*/d" $desktop
    sed -i "s|Exec=.*|Exec=i4Tools %u|" $desktop
    sed -i "s|Icon=.*|Icon=i4Tools|" $desktop
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "iOS device management tool";
    homepage = "https://www.i4.cn";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "i4Tools";
  };
}
