{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-shaderfilter";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-shaderfilter";
    rev = version;
    sha256 = "sha256-QMN2zMhT125sQ2bFAZ5oMcqfYaRo/wwyerCqGKNCszM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = {
    description = "OBS Studio filter for applying an arbitrary shader to a source";
    homepage = "https://github.com/exeldro/obs-shaderfilter";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
