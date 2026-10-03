{
  lib,
  stdenv,
  fetchFromGitHub,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "accuraterip-checksum";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "leo-bogert";
    repo = "accuraterip-checksum";
    tag = "version${finalAttrs.version}";
    hash = "sha256-cqXlNqA3AqOA5A9dhMvzGdIWnlDEfuViJgksiY6Py6g=";
  };

  buildInputs = [ libsndfile ];

  installPhase = ''
    runHook preInstall

    install -D -m755 accuraterip-checksum "$out/bin/accuraterip-checksum"

    runHook postInstall
  '';

  meta = {
    description = "Program for computing the AccurateRip checksum of singletrack WAV files";
    homepage = "https://github.com/leo-bogert/accuraterip-checksum";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "accuraterip-checksum";
  };
})
