{
  fetchFromGitHub,
  freetype,
  lib,
  lua5_4,
  meson,
  ninja,
  cmake,
  pcre2,
  pkg-config,
  sdl3,
  stdenv,
}:
let
  pname = "lite-xl";
  version = "2.1.8";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lite-xl";
    repo = "lite-xl";
    rev = "v${version}";
    hash = "sha256-9JpD7f5vOGhLW8dBjjYUI5PSaz/XWW5sIOZCAbKhxtE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    freetype
    lua5_4
    pcre2
    sdl3
  ];

  # Fix SDL3 static linking issue
  postPatch = ''
    substituteInPlace src/meson.build \
      --replace-fail "dependency('sdl3', static: true)" "dependency('sdl3', static: false)"
  '';

  mesonFlags = [
    "-Duse_system_lua=true"
  ];

  meta = {
    description = "Lightweight text editor written in Lua";
    homepage = "https://github.com/lite-xl/lite-xl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sefidel
    ];
    platforms = lib.platforms.unix;
    mainProgram = "lite-xl";
  };
}
