{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  dbus,
  libconfig,
  libxcb,
  libxft,
  libxinerama,
  yajl,

  # passthru
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dusk";
  version = "0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "bakkeby";
    repo = "dusk";
    rev = "4775b91d88859cb314bc710369578eff8ac2a850";
    hash = "sha256-D82ALoa7Tyquy9qHtavqct/vJq4S574P2ZUG/WGjIYc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    libconfig
    libxcb
    libxft
    libxinerama
    yajl
  ];

  # Place X11 desktop session files in nix store instead of
  # /usr/share/xsessions
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/share/xsessions "$out/share/xsessions"
  '';

  preBuild = ''
    makeFlagsArray+=(
      "PREFIX=$out"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/bakkeby/dusk";
    description = "DWM fork with workspaces and other features";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "dusk";
    maintainers = with lib.maintainers; [ evanwporter ];
  };
})
