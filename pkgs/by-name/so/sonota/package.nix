{ fetchFromGitHub, fetchurl, lib, python3Packages
, coreVersion ? "1.13.3" # the version of the binary espurna image to flash
, coreSize    ? "1MB"    # size of the binary image to flash
, coreSha256  ? "0pkb2nmml0blrfiqpc46xpjc2dw927i89k1lfyqx827wanhc704x" }:

with python3Packages;

let
  core = fetchurl {
    url    = "https://github.com/xoseperez/espurna/releases/download/${coreVersion}/espurna-${coreVersion}-espurna-core-${coreSize}.bin";
    sha256 = coreSha256;
  };

in buildPythonApplication rec {
  pname = "sonota-unstable";
  version = "2018-10-07";

  src = fetchFromGitHub {
    owner  = "mirko";
    repo   = "SonOTA";
    rev    = "d7f4b353858aae7ac403f95475a35560fb7ffeae";
    sha256 = "0jd9xrhcyk8d2plbjnrlpn87536zr6n708797n0k5blf109q3c1z";
  };

  patches = [
    ./set_resource_path.patch
  ];

  postPatch = ''
    substituteInPlace sonota.py --subst-var out
  '';

  format = "other";

  propagatedBuildInputs = [ httplib2 netifaces tornado ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sonota.py $out/bin/sonota
    install -d $out/share/sonota
    cp -r ssl static $out/share/sonota
    cp ${core} $out/share/sonota/static/image_arduino.bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flash Itead Sonoff devices with custom firmware via original OTA mechanism";
    homepage = src.meta.homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "sonota";
  };
}
