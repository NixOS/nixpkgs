{ lib
, stdenv
, cmake
, pkg-config
, glib
, fetchFromGitHub
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

  meta = with lib; {
    homepage = "https://github.com/lyokha/g3kb-switch";
    changelog = "https://github.com/lyokha/g3kb-switch/releases/tag/${src.rev}";
    description = "CLI keyboard layout switcher for GNOME Shell";
    mainProgram = "g3kb-switch";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.unix;
  };
}
