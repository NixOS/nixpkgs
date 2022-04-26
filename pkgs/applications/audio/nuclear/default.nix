{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron }:

# Using mkDerivation to wrap binary as a temporary fix for https://github.com/nukeop/nuclear/issues/1268
stdenv.mkDerivation rec {
  # This version works fine compared to the latest stable
  pname = "nuclear";
  version = "unstable-2022-04-20";
  releaseCode = "bc8b7b";
  name = "${pname}-${releaseCode}";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/${releaseCode}/${name}.AppImage";
    sha256 = "sha256-JBVr1xnTE/ePX+SZMyZpMCACtz9W/HdweOr96ib4+xk=";
  };

  appimageContents = appimageTools.extract { inherit name src; };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    install -m 444 -D ${appimageContents}/nuclear.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/nuclear.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --add-flags "--no-sandbox"
  '';

  meta = with lib; {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}
