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
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-text-pthread";
    rev = version;
    sha256 = "sha256-YjMZfDSO5VRIY+HBGniNV3HG5vs+zbiqfbrPKs9v804=";
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

  meta = with lib; {
    description = "Rich text source plugin for OBS Studio";
    homepage = "https://github.com/norihiro/obs-text-pthread";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
