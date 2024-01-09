{ lib
, stdenvNoCC
, fetchFromGitHub
, gawk
, hexdump
, jq
, pipewire
, psmisc
}:
stdenvNoCC.mkDerivation rec {
  name = "pipewire-screenaudio";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "IceDBorn";
    repo = "pipewire-screenaudio";
    rev = version;
    hash = "sha256-aqQkllnYqL6KvrZiRdhp9QzkhhI+Ey2SRSpHL1DkL6o=";
  };

  buildInputs = [
    gawk
    hexdump
    jq
    pipewire
    psmisc
  ];

  postInstall = ''
    mkdir -p $out/lib/out
    install -Dm755 native/connector/pipewire-screen-audio-connector.sh $out/lib/connector/pipewire-screen-audio-connector.sh
    install -Dm755 native/connector/virtmic.sh $out/lib/connector/virtmic.sh
    install -Dm755 native/connector/connect-and-monitor.sh $out/lib/connector/connect-and-monitor.sh

    # Firefox manifest
    substituteInPlace native/native-messaging-hosts/firefox.json \
      --replace /usr/lib/pipewire-screenaudio $out/lib
    install -Dm644 native/native-messaging-hosts/firefox.json $out/lib/mozilla/native-messaging-hosts/com.icedborn.pipewirescreenaudioconnector.json
  '';

  meta = with lib; {
    description = "The native application required by the Firefox extension Pipewire Screenaudio";
    homepage = "https://github.com/IceDBorn/pipewire-screenaudio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ icedborn ];
    platforms = lib.platforms.linux;
  };
}
