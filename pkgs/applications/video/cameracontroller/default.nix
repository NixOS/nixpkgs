{ lib
, stdenv
, fetchurl
, unzip
, makeWrapper
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "cameracontroller";
  version = "1.4.0";

  # TODO move to building from source if swift becomes unbroken one day
  src = fetchurl {
    url = "https://github.com/Itaybre/CameraController/releases/download/v${version}/CameraController.zip";
    hash = "sha256-ikbcsgqNiJjUxHVA9jbpkMo+NAHA/wYgQ+/lzDPTndo";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  doBuild = false;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -d $out/Applications/CameraController.app/
    cp -r Contents $out/Applications/CameraController.app/
    install -d $out/bin/
    makeWrapper $out/Applications/CameraController.app/Contents/MacOS/CameraController $out/bin/CameraController
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Control USB cameras from most manufacturers using a common interface";
    homepage = "https://github.com/Itaybre/CameraController";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viraptor ];
    platform = platforms.darwin;
  };
}
