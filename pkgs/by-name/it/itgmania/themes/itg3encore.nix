{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg3encore";
  version = "0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "DarkBahamut162";
    repo = "itg3encore";
    rev = "6a7006c4c9726d302e54ccd6d85a718e03a11d5a";
    hash = "sha256-AduW2+MhRFxHGXySziuz/IK8cLAjBjUMr62JmUyAiJA=";
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
