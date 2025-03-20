{
  lib,
  stdenvNoCC,
  fetchurl,
  libarchive,
  p7zip,
  testers,
  mas,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mas";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-MiSrCHLby3diTAzDPCYX1ZwdmzcHwOx/UJuWrlRJe54=";
  };

  nativeBuildInputs = [
    libarchive
    p7zip
  ];

  unpackPhase = ''
    runHook preUnpack

    7z x $src
    bsdtar -xf Payload~

    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp mas $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = mas;
      command = "mas version";
    };
  };

  meta = with lib; {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = licenses.mit;
    maintainers = with maintainers; [
      steinybot
      zachcoyle
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
