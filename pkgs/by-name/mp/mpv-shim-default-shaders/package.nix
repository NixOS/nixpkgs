{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mpv-shim-default-shaders";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "default-shader-pack";
    rev = "v${version}";
    sha256 = "sha256-lHFidCHBduvNBy1HGgqLDqZMJeLv3jfVWQ73Hlev7w8=";
  };

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp -r shaders *.json $out/share/${pname}
  '';

  meta = {
    homepage = "https://github.com/iwalton3/default-shader-pack";
    description = "Preconfigured set of MPV shaders and configurations for MPV Shim media clients";
    license = with lib.licenses; [
      gpl3Plus
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ devusb ];
  };
}
