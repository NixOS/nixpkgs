{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-retro-effects";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-retro-effects";
    rev = "${version}";
    sha256 = "sha256-oQGXBd/KGPGTK+CoomMjjgrnxTqVIefEKqKH11SPHSY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postFixup = ''
    mv $out/data/obs-plugins/${pname}/shaders $out/share/obs/obs-plugins/${pname}/
    rm -rf $out/obs-plugins
    rm -rf $out/data
  '';

  meta = {
    description = "Collection of OBS filters to give your stream that retro feel";
    homepage = "https://github.com/FiniteSingularity/obs-retro-effects";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
