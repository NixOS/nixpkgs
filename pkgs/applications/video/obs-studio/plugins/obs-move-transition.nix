{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-move-transition";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-move-transition";
    rev = version;
    sha256 = "sha256-CDQRRJV7xbdvSsPfholfw85aHXPgNBvQx5ZxqURe6n8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Plugin for OBS Studio to move source to a new position during scene transition";
    homepage = "https://github.com/exeldro/obs-move-transition";
    maintainers = with lib.maintainers; [ starcraft66 ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
