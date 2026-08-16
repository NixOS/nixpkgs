{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zmod-simply-love";
  version = "5.9.0-july-2";

  src = fetchFromGitHub {
    owner = "zarzob";
    repo = "Simply-Love-SM5";
    tag = finalAttrs.version;
    hash = "sha256-1sUiUPg5MzPZhdGdx3LqDbUIcSD+TkGKifj55S8MieQ=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/Zmod Simply Love"
    mv * "$out/itgmania/Themes/Zmod Simply Love"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zmod fork of Simply Love";
    homepage = "https://github.com/zarzob/Simply-Love-SM5";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      maxwell-lt
      ungeskriptet
    ];
  };
})
