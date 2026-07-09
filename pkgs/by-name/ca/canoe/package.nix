{
  river,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wayland,
  libxkbcommon,
  freetype,
  fontconfig,
  makeDesktopItem,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "canoe";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHaoeLQhj0L+1URXIrgfuFkAScXVVWqDiGdxq14zUqI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    wayland
    libxkbcommon
    freetype
    fontconfig
  ];

  cargoHash = "sha256-qMzqyZ6dSyIYhsXBjvtSiX4pptKP+6G3fze8NSPeza4=";

  postInstall =
    let
      desktopItem = makeDesktopItem {
        name = "canoe";
        desktopName = "Canoe";
        comment = finalAttrs.meta.description;
        exec = "${lib.getExe river} -c ${finalAttrs.meta.mainProgram}";
      };
    in
    ''
      install -Dm644 ${desktopItem}/share/applications/canoe.desktop -t $out/share/wayland-sessions/
    '';
  passthru.providedSessions = [ "canoe" ];

  meta = {
    mainProgram = "canoe";
    description = "Stacking window manager for the River Wayland compositor, written in Rust";
    homepage = "https://github.com/roblillack/canoe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ astro ];
  };
})
