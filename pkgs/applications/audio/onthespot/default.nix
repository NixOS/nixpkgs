{ lib,
  buildPythonApplication,
  fetchFromGitHub,
  symlinkJoin,
  makeWrapper,
  qt5,
  setuptools,
  certifi,
  charset-normalizer,
  defusedxml,
  ffmpeg,
  idna,
  ifaddr,
  librespot,
  music-tag,
  mutagen,
  packaging,
  pillow,
  protobuf,
  pycryptodomex,
  pyogg,
  pyqt5,
  pyqt5_sip,
  pyxdg,
  requests,
  show-in-file-manager,
  urllib3,
  websocket-client,
  zeroconf,
}:
buildPythonApplication rec {
  pname = "onthespot";
  version = "0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "onthespot";
    rev = "v${version}";
    hash = "sha256-VaJBNsT7uNOGY43GnzhUqDQNiPoFZcc2UaIfOKgkufg=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    setuptools
  ];
  propagatedBuildInputs = [
    qt5.wrapQtAppsHook
    certifi
    charset-normalizer
    defusedxml
    idna
    ifaddr
    librespot
    music-tag
    mutagen
    packaging
    pillow
    protobuf
    pycryptodomex
    pyogg
    pyqt5
    pyqt5_sip
    pyxdg
    requests
    show-in-file-manager
    urllib3
    websocket-client
    zeroconf
  ];

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  postInstall = ''
    wrapProgram $out/bin/onthespot_gui \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    description = "qt based music downloader written in python";
    homepage = "https://github.com/casualsnek/onthespot";
    license = licenses.gpl2Only;
    mainProgram = "onthespot_gui";
    maintainers = with maintainers; [ passivelemon ];
    platforms = [ "x86_64-linux" ];
  };
}
