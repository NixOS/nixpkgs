{
  lib,
  stdenv,
  fetchFromCodeberg,

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
  version = "1.0-unstable-2026-03-18";

  src = fetchFromCodeberg {
    owner = "sewn";
    repo = "mew";
    rev = "98dea211e634ccc2f75b4dae09fc2705666c6322";
    hash = "sha256-u0TBWPBOdXNYwuwn9U1xqJsUShyOz9MIP1CNozcxbzg=";
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
    # Disables the incompatible-pointer-types build check.
    "CFLAGS=-Wno-error=incompatible-pointer-types"
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
