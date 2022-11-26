{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, python
, alicevision
, qt5
, libsForQt5
}: let
  pyside2_3d = python.pkgs.pyside2.overrideAttrs (self: super: {
    buildInputs = super.buildInputs ++ (with qt5; [
      qt3d
    ]);
  });
  pyenv = python.withPackages (p: with p; [
    pyside2_3d
    psutil
    markdown
    requests
  ]);
  voctree = fetchurl {
    url = "https://gitlab.com/alicevision/trainedVocabularyTreeData/raw/master/vlfeat_K80L3.SIFT.tree";
    sha256 = "SuecIXD7tUoAGV+GbytCE+orS8MD9FG2s2Bwmh0ZTLg=";
  };
in stdenv.mkDerivation rec {
  pname = "meshroom";
  version = "2022.11.15";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = pname;
    rev = "8e9128be8d58f2caf55ad9bc9a41e86798dfd5eb";
    sha256 = "IDoP0JnSI7zz/GSMQZCTQGw5Qg0qr7zMdDqwZJ7OE18=";
  };
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
          mkdir -p $out/{bin,lib}
          cp -r $src/meshroom $out/lib/
        '';
  dontWrapQtApps = true;
  postFixup = ''
          qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
          makeQtWrapper ${pyenv}/bin/python3 $out/bin/meshroom \
                      --prefix PYTHONPATH : $out/lib/ \
                      --prefix PATH : ${alicevision}/bin/ \
                      --prefix ALICEVISION_SENSOR_DB : ${alicevision}/share/aliceVision/cameraSensors.db \
                      --prefix ALICEVISION_VOCTREE : ${voctree} \
                      --prefix ALICEVISION_ROOT : ${alicevision} \
                      --add-flags $out/lib/meshroom/ui
        '';
  buildInputs = (with qt5; [
    qt3d
    qtcharts
  ]) ++ (with libsForQt5; [ 
    qmlalembic
    qtoiio
    qtalicevision
  ]);
  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ mpl20 mit ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ davidcromp ];
  };
}
