{
  lib,
  stdenv,
  cmake,
  pkg-config,
  glib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "g3kb-switch";
  version = "1.5";
  src = fetchFromGitHub {
    owner = "lyokha";
    repo = "g3kb-switch";
    rev = version;
    hash = "sha256-kTJfV0xQmWuxibUlfC1qJX2J2nrZ4wimdf/nGciQq0Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    glib
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/lyokha/g3kb-switch";
    changelog = "https://github.com/lyokha/g3kb-switch/releases/tag/${src.rev}";
    description = "CLI keyboard layout switcher for GNOME Shell";
    mainProgram = "g3kb-switch";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Freed-Wu ];
    platforms = lib.platforms.unix;
=======
    license = licenses.bsd2;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
