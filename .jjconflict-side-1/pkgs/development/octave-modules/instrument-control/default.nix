{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "instrument-control";
    tag = "release-${version}";
    sha256 = "sha256-eXlH7BFRh4Vq/2LiBsmTvZNhXm4IbeCHK+OsKMQI0tY=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/instrument-control/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
