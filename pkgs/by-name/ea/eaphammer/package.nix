{
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  makeWrapper,
  apacheHttpd,
  curl,
  dnsmasq,
  hcxdumptool,
  hcxtools,
  libnfnetlink,
  libnl,
  libpcap,
  openssl,
  pkg-config,
  responder,
}:

python3Packages.buildPythonApplication rec {
  pname = "eaphammer";
  version = "1.14.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "s0lst1c3";
    repo = "eaphammer";
    rev = "refs/tags/v${version}";
    hash = "sha256-LUqUSfM4U5adOk5yaM05wTE/47iKXiA46FzSP3peivw=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    curl
    dnsmasq
    hcxdumptool
    hcxtools
    libnfnetlink
    libnl
    libpcap
    openssl
    responder
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    flask
    flask-cors
    flask-socketio
    gevent
    lxml
    pem
    pyopenssl
    pywebcopy
    requests
    scapy
    tqdm
  ];

  buildPhase = ''
    runHook preBuild
    cd local/hostapd-eaphammer/hostapd
    cp defconfig .config
    make hostapd-eaphammer_lib
    cd ../../..
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/eaphammer}
    rm README.md *.txt
    cp -a * $out/share/eaphammer/
    makeWrapper ${python3}/bin/python $out/bin/eaphammer \
      --add-flags "$out/share/eaphammer/eaphammer" \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath dependencies}
    runHook postInstall
  '';

  meta = {
    description = "Targeted evil twin attacks against WPA2-Enterprise networks";
    homepage = "https://github.com/s0lst1c3/eaphammer";
    changelog = "https://github.com/s0lst1c3/eaphammer/blob/v${version}/Changelog";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eaphammer";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
  };
}
