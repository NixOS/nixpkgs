{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fontconfig,
  inkscape,
  which,
  writableTmpDirAsHomeHook,
  xcursorgen,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mcmojave-cursors";
  version = "0-unstable-2021-02-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "McMojave-cursors";
    rev = "7d0bfc1f91028191cdc220b87fd335a235ee4439";
    hash = "sha256-4YqSucpxA7jsuJ9aADjJfKRPgPR89oq2l0T1N28+GV0=";
  };

  strictDeps = true;

  postPatch = ''
    patchShebangs build.sh
  '';

  nativeBuildInputs = [
    fontconfig
    inkscape
    which
    writableTmpDirAsHomeHook
    xcursorgen
  ];

  buildPhase = ''
    runHook preBuild

    export FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf"

    rm -rf dist
    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 "$out/share/icons"
    cp -a dist "$out/share/icons/McMojave-cursors"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "macOS Mojave-inspired X cursor theme";
    homepage = "https://github.com/vinceliuice/McMojave-cursors";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    platforms = lib.platforms.unix;
  };
}
