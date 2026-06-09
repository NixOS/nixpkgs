{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg3encore";
  version = "0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "DarkBahamut162";
    repo = "itg3encore";
    rev = "7aad94a63462efc85eb6e0e23bd0bd50be28137c";
    hash = "sha256-oaj76RMD+Ibm8n8/EiUZYVBlyy5PefpBsWhFbWEjM08=";
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
