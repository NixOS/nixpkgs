{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-move-transition";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-move-transition";
    rev = version;
    sha256 = "sha256-YA66qSCchZbA5TowOqn1FNvAtPzxREIChVJleoaImxk=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/exeldro/obs-move-transition/commit/06311ee01d7f436a67b9ca562c41e3bba4f4770f.patch";
      hash = "sha256-lIV8MBQ17Cue0tDI0vS3P+juj367bpEAFXeo47x7vws=";
    })
  ];

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
