{
  fetchFromGitHub,
  lib,
  stdenv,
  boost186,
  soapysdr-with-plugins,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dump978";
  version = "11.0";
  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump978";
    tag = "v${finalAttrs.version}";
    hash = "sha256-phXdZNin0wuV8lSOUIgQ1IvtqH+WClD2ApuI8nftQUo=";
  };

  enableParallelBuilding = true;

  buildInputs = [
    boost186
    soapysdr-with-plugins
  ];

  makeFlags = [ "VERSION=${finalAttrs.version}" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -v dump978-fa skyaware978 $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "FlightAware's 978MHz UAT demodulator";
    homepage = "https://github.com/flightaware/dump978";
    license = licenses.bsd2;
    maintainers = with maintainers; [ xddxdd ];
    mainProgram = "dump978-fa";
  };
})
