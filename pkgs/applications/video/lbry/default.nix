{ stdenv
, dpkg
, fetchurl
, atomEnv
, autoPatchelfHook
, libpulseaudio
, makeWrapper
, pulseaudio
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "lbry";
  version = "0.44.0";
  
  src = fetchurl {
    url = "https://github.com/lbryio/lbry-desktop/releases/download/v${version}/LBRY_${version}.deb";
    sha256 = "0v3w6qi3lyalyaz9n8dpssgjkxjlwn30f7gc4b8fh8cpdkgdk6dp";
  };
  
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = atomEnv.packages ++ [ libpulseaudio ];
  
  unpackPhase = ''
    dpkg -x $src /build
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    mv usr/share $out/share
    mv opt/LBRY $out/LBRY
    makeWrapper $out/LBRY/lbry $out/bin/lbry \
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib:${pulseaudio}/lib
  '';
}
