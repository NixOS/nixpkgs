{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  pkg-config,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jack-link";
<<<<<<< HEAD
  version = "0.2.6";
=======
  version = "0.2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "jack_link";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-mZ74nkiAQHkJAZYHTsNcQnrisaUIyHwEDUbrvOL6CAU=";
=======
    hash = "sha256-UYyVGc9/NOLzFD/31zB9lhUJW8G/PGt7VkSBjntpymw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libjack2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/rncbc/jack_link";
    description = "jack_link bridges JACK transport with Ableton Link";
    license = lib.licenses.gpl2Plus;
    mainProgram = "jack_link";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
