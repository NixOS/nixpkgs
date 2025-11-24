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
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-v+tiD5ZMVFzeShyuOt8Ss3yw6p8VjopHaMimOQznL6o=";
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
    mainProgram = "mas";
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
