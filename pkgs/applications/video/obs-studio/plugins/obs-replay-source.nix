{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-replay-source";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-replay-source";
    rev = version;
    sha256 = "sha256-+PSALDqHXPyR0J7YnLn3QgPN6eIoH3yTIm1Bp7Li8c8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

<<<<<<< HEAD
  meta = {
    description = "Replay source for OBS studio";
    homepage = "https://github.com/exeldro/obs-replay-source";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Replay source for OBS studio";
    homepage = "https://github.com/exeldro/obs-replay-source";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      flexiondotorg
      pschmitt
    ];
  };
}
