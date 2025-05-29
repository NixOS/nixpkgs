{
  lib,
  fetchFromGitLab,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin hyprland {
  pluginName = "hyprslidr";
  version = "0-unstable-2025-05-16";

  src = fetchFromGitLab {
    owner = "magus";
    repo = "hyprslidr";
    rev = "d0e0ba745df8e1ce17f58a4cac0072db7d85ab77";
    hash = "sha256-TTxBjRYyI/JsmrFCAz0UNrpKbLxGm6SQvPj8LrDSKvI=";
  };

  # allows it to load in 0.49.1
  patches = [ ./hyprslidr-fix.patch ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv ./hyprslidr.so $out/lib/libhyprslidr.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Hyprland plugin for a sliding window layout. Inspired by PaperWM.";
    homepage = "https://gitlab.com/magus/hyprslidr";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ youwen5 ];
    platforms = lib.platforms.linux;
  };
}
