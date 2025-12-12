{
  lib,
  stdenv,
  fetchFromGitea,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  fcft,
  libxkbcommon,
  pixman,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
stdenv.mkDerivation {
  pname = "mew";
  version = "1.0-unstable-2025-06-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "mew";
    rev = "af6440da8fe6683cf0b873e0a98c293bf02c3447";
    hash = "sha256-NbpYITHO81fnaDY0dtolaUBdRqQNKwHQz/lBQMOHM5c=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wayland-scanner
  ];

  makeFlags = [
    # The PREFIX var is hardcoded in the makefile.
    "PREFIX=$(out)"
  ];

  postFixup = ''
    substituteInPlace $out/bin/mew-run \
      --replace-fail \
        'path | mew -e "$@"' \
        'path | ${placeholder "out"}/bin/mew -e "$@"'
  '';

  meta = {
    description = "Efficient dynamic menu for Wayland, an effective port of dmenu to Wayland";
    homepage = "https://codeberg.org/sewn/mew";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Notarin ];
    platforms = lib.platforms.linux;
    mainProgram = "mew";
  };
}
