{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libinput,
  xdotool,
  makeWrapper,
}:

rustPlatform.buildRustPackage {
  pname = "libinput-three-finger-drag";
  version = "0.1-unstable-2024-06-17";

  src = fetchFromGitHub {
    owner = "marsqing";
    repo = "libinput-three-finger-drag";
    rev = "6acd3f84b551b855b5f21b08db55e95dae3305c5";
    hash = "sha256-xmcTb+23d6mMzIfMVjzN6bwV0fWH4p6YhXXqrFmt4TM=";
  };
  cargoHash = "sha256-D8a+kaINXqYkNmh1NJWom1p9/ziEzUoJvcknJPZxOS4=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ xdotool ];

  postFixup = ''
    wrapProgram "$out/bin/libinput-three-finger-drag" \
      --prefix PATH : "${lib.makeBinPath [ libinput ]}"
  '';

  meta = {
    description = "Three-finger-drag support for libinput.";
    homepage = "https://github.com/marsqing/libinput-three-finger-drag";
    license = with lib.licenses; [ mit ];
    mainProgram = "libinput-three-finger-drag";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
}
