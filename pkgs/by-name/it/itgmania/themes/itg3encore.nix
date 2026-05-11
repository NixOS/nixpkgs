{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg3encore";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "DarkBahamut162";
    repo = "itg3encore";
    rev = "92fa3cb3234e466891606a047e4d2d104839581b";
    hash = "sha256-tnb9uGu4VaXlNh9QRbPtCKHS2GWmfFBOMe8/uW9hA0Q=";
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
