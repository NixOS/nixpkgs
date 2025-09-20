{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  pcsclite,
}:

stdenv.mkDerivation {
  pname = "aribb25";
  # FIXME: change the rev for fetchFromGitLab in next release
  version = "0.2.7";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "aribb25";
    # rev = version; FIXME: uncomment in next release
    rev = "c14938692b313b5ba953543fd94fd1cad0eeef18"; # 0.2.7 with build fixes
    hash = "sha256-tyrRFg6nyba1UxZ9W0bFcH2K/zDrkyl9vBasiF1mac0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-deprecated-non-prototype";

  patches =
    let
      url = commit: "https://code.videolan.org/videolan/aribb25/-/commit/${commit}.diff";
    in
    [
      (fetchpatch {
        name = "make-cli-pipes-work-1.patch";
        url = url "0425184dbf3fdaf59854af5f530da88b2196a57b";
        hash = "sha256-jQWlsVRLmghpYSAWAPoTnHdsghEgBL7D+R3bu6MUVXs=";
      })
      (fetchpatch {
        name = "make-cli-pipes-work-2.patch";
        url = url "cebabeab2bda065dca1c9f033b42d391be866d86";
        hash = "sha256-SDQ4jLWDdOiIaIw2i2Cd8nUGJ7xQbA3UUiuTHDaeA4k=";
      })
    ];

  meta = with lib; {
    description = "Sample implementation of the ARIB STD-B25 standard";
    homepage = "https://code.videolan.org/videolan/aribb25";
    license = licenses.isc;
    maintainers = with maintainers; [ midchildan ];
    mainProgram = "b25";
    platforms = platforms.all;
  };
}
