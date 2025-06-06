{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, doxygen
, wrapQtAppsHook
, pcre
, poco
, qtbase
, qtsvg
, qwt6_1
, nlohmann_json
, soapysdr-with-plugins
, portaudio
, alsa-lib
, muparserx
, python3
}:

mkDerivation rec {
  pname = "pothos";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "PothosCore";
    rev = "pothos-${version}";
    sha256 = "038c3ipvf4sgj0zhm3vcj07ymsva4ds6v89y43f5d3p4n8zc2rsg";
    fetchSubmodules = true;
  };

  patches = [
    # spuce's CMakeLists.txt uses QT5_USE_Modules, which does not seem to work on Nix
    ./spuce.patch
    # Poco had some breaking API changes in 1.12
    (fetchpatch {
      name = "poco-1.12-compat.patch";
      url = "https://github.com/pothosware/PothosCore/commit/092d1209b0fd0aa8a1733706c994fa95e66fd017.patch";
      hash = "sha256-bZXG8kD4+1LgDV8viZrJ/DMjg8UvW7b5keJQDXurfkA=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config doxygen wrapQtAppsHook ];

  buildInputs = [
    pcre poco qtbase qtsvg qwt6_1 nlohmann_json
    soapysdr-with-plugins portaudio alsa-lib muparserx python3
  ];

  postInstall = ''
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow.desktop $out/share/applications/pothos-flow.desktop
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-16.png $out/share/icons/hicolor/16x16/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-22.png $out/share/icons/hicolor/22x22/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-32.png $out/share/icons/hicolor/32x32/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-48.png $out/share/icons/hicolor/48x48/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-64.png $out/share/icons/hicolor/64x64/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow-128.png $out/share/icons/hicolor/128x128/apps/pothos-flow.png
    install -Dm644 $out/share/Pothos/Desktop/pothos-flow.xml $out/share/mime/application/pothos-flow.xml
    rm -r $out/share/Pothos/Desktop
  '';

  dontWrapQtApps = true;
  preFixup = ''
    # PothosUtil does not need to be wrapped
    wrapQtApp $out/bin/PothosFlow
    wrapQtApp $out/bin/spuce_fir_plot
    wrapQtApp $out/bin/spuce_iir_plot
    wrapQtApp $out/bin/spuce_other_plot
    wrapQtApp $out/bin/spuce_window_plot
  '';

  meta = with lib; {
    description = "Pothos data-flow framework";
    homepage = "https://github.com/pothosware/PothosCore/wiki";
    license = licenses.boost;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
