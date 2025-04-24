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

  meta = with lib; {
    description = "Intelligent Chinese phonetic input method";
    homepage = "https://chewing.im/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      ericsagnes
      ShamrockLee
    ];
    platforms = platforms.all;
  };
})
