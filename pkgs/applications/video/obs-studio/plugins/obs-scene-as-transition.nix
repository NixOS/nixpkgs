{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-scene-as-transition";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "andilippi";
    repo = "obs-scene-as-transition";
    rev = "v${version}";
    sha256 = "sha256-qeiJR68MqvhpzvY7yNnR6w77SvavlZTdbnGBWrd7iZM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "OBS Studio plugin that will allow you to use a Scene as a transition";
    homepage = "https://github.com/andilippi/obs-scene-as-transition";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
