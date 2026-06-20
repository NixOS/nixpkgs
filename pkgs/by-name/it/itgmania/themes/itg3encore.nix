{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg3encore";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "DarkBahamut162";
    repo = "itg3encore";
    rev = "409dc62c7c7a6c3ce3a713e84c81d95995eb20a6";
    hash = "sha256-sJLkHRngmA9dPZoQPpUdOAz1nLCHTTOPG4i/SP6rl9A=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/ITG3Encore"
    mv * "$out/itgmania/Themes/ITG3Encore"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "An upgraded port of ITG3's Encore theme";
    homepage = "https://github.com/DarkBahamut162/itg3encore";
    # https://github.com/DarkBahamut162/itg3encore/issues/16
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
