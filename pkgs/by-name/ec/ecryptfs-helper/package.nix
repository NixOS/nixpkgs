{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "ecryptfs-helper";
  version = "unstable-2023-01-10";

  src = fetchurl {
    url = "https://gist.github.com/obadz/ec053fdb00dcb48441d8313169874e30/raw/6ca5fb56df181a2f65a02e4d21553cfd204370df/ecryptfs-helper.py";
    hash = "sha256-dlUvY67HsoGa0dnFl9OgiSMJm4Pd/DQXOAMpU59LXo4=";
  };

  dontUnpack = true;

  buildInputs = [
    python3
  ];

  # Do not hardcode PATH to ${ecryptfs} as we need the script to invoke executables from /run/wrappers/bin
  installPhase = ''
    runHook preInstall
    install -Dm555 "$src" "$out/bin/ecryptfs-helper"
    runHook postInstall
  '';

  meta = {
    description = "Helper script to create/mount/unemount encrypted directories using eCryptfs without needing root permissions";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ obadz ];
    platforms = lib.platforms.linux;
    mainProgram = "ecryptfs-helper";
  };
}
