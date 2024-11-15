{
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
  nix-update-script,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "breezex-cursor";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "BreezeX_Cursor";
    rev = "refs/tags/v${version}";
    hash = "sha256-P9LgQb3msq6YydK5RIk5yykUd9SL2GQbC4aH4F8LUF0=";
  };

  nativeBuildInputs = [ clickgen ];

  bitmaps = fetchzip {
    url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/bitmaps.zip";
    hash = "sha256-JncEE+G4tPgcLgabe/dD7DOVMLOWCI7e+3VdmXuZSo8=";
  };

  buildPhase = ''
    runHook preBuild
    ctgen configs/x.build.toml -p x11 -d "$bitmaps/BreezeX-Dark" -n "BreezeX-Dark" -c "Extended KDE Dark (v2.0.1)"
    ctgen configs/x.build.toml -p x11 -d "$bitmaps/BreezeX-Black" -n "BreezeX-Black" -c "Extended KDE Black (v2.0.1)"
    ctgen configs/x.build.toml -p x11 -d "$bitmaps/BreezeX-Light" -n "BreezeX-Light" -c "Extended KDE Light (v2.0.1)"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -dm 0755 $out/share/icons
    cp -rf themes/* $out/share/icons/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extended KDE cursor theme, inspired by KDE Breeze";
    homepage = "https://github.com/ful1e5/BreezeX_Cursor";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pagedMov ];
  };
}
