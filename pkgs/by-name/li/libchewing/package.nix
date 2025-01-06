{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libchewing";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "libchewing";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-X+4Rr5Mfc4qeJxmHczu4MKgHBvQN1rhqUrJSx8SFnDk=";
  };

  buildInputs = [ sqlite ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Intelligent Chinese phonetic input method";
    homepage = "https://chewing.im/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      ericsagnes
      ShamrockLee
    ];
    platforms = lib.platforms.all;
  };
})
