{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gdbuspp";
  version = "2";
  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "gdbuspp";
    rev = "refs/tags/v${version}";
    hash = "sha256-A0sl4zZa17zMec/jJASE8lDVNohzJzEGZbWjjsorB2Y=";
  };

  postPatch = ''
    patchShebangs --build ./scripts/get-git-ref
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ glib ];

  meta = {
    description = "GDBus++ - a glib2 D-Bus wrapper for C++";
    longDescription = ''
      This library provides a simpler C++ based interface to implement D-Bus
      into applications in a more C++ approach, based on the C++17 standard.
    '';
    homepage = "https://codeberg.org/OpenVPN/gdbuspp";
    changelog = "https://codeberg.org/OpenVPN/gdbuspp/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    platforms = lib.platforms.linux;
  };
}
