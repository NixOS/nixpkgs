{ lib
, fetchurl
, undmg
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "basecamp";
  version = "2.3.8";
  src =
    let
      base = "https://bc3-desktop.s3.amazonaws.com";
    in
      {
        aarch64-darwin = fetchurl {
          url = "${base}/mac_arm64/basecamp3_arm64.dmg";
          sha256 = "sha256-LESKioh4XpCTEo2LlWb2nIEWbMKkmx5beRSgE2I04dk=";
        };
        x86_64-darwin = fetchurl {
          url = "${base}/mac/basecamp3.dmg";
          sha256 = "sha256-Ay+fHHrvTtqEZI2eRpQWitn77noIzDuVMRgezNM9WEY=";
        };
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = "Basecamp 3.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p "$out/Applications/Basecamp 3.app"
    cp -R . "$out/Applications/Basecamp 3.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/Basecamp 3.app/Contents/MacOS/Basecamp 3" "$out/bin/basecamp"
  '';

  meta = with lib; {
    description = "Refreshingly simple project management";
    homepage = "https://basecamp.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ yamashitax ];
  };
}
