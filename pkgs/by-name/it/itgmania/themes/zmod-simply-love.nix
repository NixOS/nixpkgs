{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zmod-simply-love";
  version = "5.8.1-march";

  src = fetchFromGitHub {
    owner = "zarzob";
    repo = "Simply-Love-SM5";
    tag = finalAttrs.version;
    hash = "sha256-v5UP6qQMCdkc+mZkLyZDd+VUMtNmQg5CokzTm0vsBpM=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/Zmod Simply Love"
    mv * "$out/itgmania/Themes/Zmod Simply Love"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

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
