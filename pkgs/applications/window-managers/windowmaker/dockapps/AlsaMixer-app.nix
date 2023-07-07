{ lib, stdenv, dockapps-sources, pkg-config, libX11, libXpm, libXext, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "AlsaMixer.app";
  version = "0.2.1";

  src = dockapps-sources;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 libXpm libXext alsa-lib ];

  setSourceRoot = ''
    export sourceRoot=$(echo */${pname})
  '';

  dontConfigure = true;

  preInstall = ''
    install -d ${placeholder "out"}/bin
  '';

  installPhase = ''
    runHook preInstall
    install -t ${placeholder "out"}/bin AlsaMixer.app
    runHook postInstall
  '';

  postInstall = ''
    ln -s ${placeholder "out"}/bin/AlsaMixer.app ${placeholder "out"}/bin/AlsaMixer
  '';

  meta = with lib; {
    description = "Alsa mixer application for Windowmaker";
    homepage = "https://www.dockapps.net/alsamixerapp";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bstrik ];
  };
}
