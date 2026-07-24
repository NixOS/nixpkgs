{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cairo,
  obs-studio,
  pango,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "obs-text-pthread";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-text-pthread";
    rev = version;
    sha256 = "sha256-Br7cX1/7VYIruLA5107+PjTMNEFAE2P/cvmu5EuXbWI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
    obs-studio
    pango
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = {
    description = "Rich text source plugin for OBS Studio";
    homepage = "https://github.com/norihiro/obs-text-pthread";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
