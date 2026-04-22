{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arrowcloud-theme";
  version = "20260328";

  src = fetchFromGitHub {
    owner = "Arrow-Cloud";
    repo = "theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9BND3IUIc5uMBxzw+Pn/59jBKBK/xGWrOIgcIYIQvgk=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/Arrow Cloud"
    mv * "$out/itgmania/Themes/Arrow Cloud"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Arrow Cloud's fork of Zmod";
    homepage = "https://github.com/Arrow-Cloud/theme";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
