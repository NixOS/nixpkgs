{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixedit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "roamingparrot";
    repo = "nixos-config-manager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BF1PcsD1iXjLrbfioa7OIkb/YhN3IGWnHzlHk+1pScc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  strictDeps = true;

  preConfigure = ''
    cd src
  '';

  installPhase = ''
    runHook preInstall
    install -D nixedit --target-directory=$out/bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for managing NixOS packages";
    longDescription = ''
      nixedit is a terminal-based user interface for searching, installing,
      and removing NixOS packages by directly editing your Nix configuration files.
      It provides an intuitive way to manage your system packages without
      manually editing configuration files.
    '';
    homepage = "https://github.com/roamingparrot/nixos-config-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roamingparrot ];
    mainProgram = "nixedit";
    platforms = lib.platforms.linux;
  };
})
