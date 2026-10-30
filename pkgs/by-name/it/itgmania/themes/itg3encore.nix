{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg3encore";
  version = "0-unstable-2026-10-26";

  src = fetchFromGitHub {
    owner = "DarkBahamut162";
    repo = "itg3encore";
    rev = "bca07e4fdefa6ab553fc23296c34358312ee0892";
    hash = "sha256-mNjuO49HyK30DAJvM2r9WgNGa2n6QNv1a25DxrYztx0=";
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
