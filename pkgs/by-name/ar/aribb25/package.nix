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
    # tag = version; FIXME: uncomment in next release
    rev = "c14938692b313b5ba953543fd94fd1cad0eeef18"; # 0.2.7 with build fixes
    sha256 = "1kb9crfqib0npiyjk4zb63zqlzbhqm35nz8nafsvdjd71qbd2amp";
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
        sha256 = "0ysm2jivpnqxz71vw1102616qxww2gx005i0c5lhi6jbajqsa1cd";
      })
      (fetchpatch {
        name = "make-cli-pipes-work-2.patch";
        url = url "cebabeab2bda065dca1c9f033b42d391be866d86";
        sha256 = "1283kqv1r4rbaba0sv2hphkhcxgjkmh8ndlcd24fhx43nn63hd28";
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
