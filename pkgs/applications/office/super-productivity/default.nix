{ stdenv , lib , fetchurl , appimageTools , makeWrapper , electron }:

stdenv.mkDerivation rec {
  pname = "super-productivity";
  version = "7.8.0";

  src = fetchurl {
    url = "https://github.com/johannesjo/super-productivity/releases/download/v${version}/superProductivity-${version}.AppImage";
    sha256 = "dbc92022efc3a0ac565259b57034412bb3fc4b86c084d98b8b96369c916e9f7a";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/superproductivity.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "To Do List / Time Tracker with Jira Integration";
    homepage = "https://super-productivity.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ offline ];
  };
}
