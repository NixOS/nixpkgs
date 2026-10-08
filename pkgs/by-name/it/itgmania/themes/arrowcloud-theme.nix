{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arrowcloud-theme";
  version = "20260901.2";

  src = fetchFromGitHub {
    owner = "Arrow-Cloud";
    repo = "theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-In+XfEHlq5UOJgaSxhosALcJ7lqnLnTf/7yevyMNOPY=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/Arrow Cloud"
    mv * "$out/itgmania/Themes/Arrow Cloud"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Arrow Cloud's fork of Zmod";
    homepage = "https://github.com/Arrow-Cloud/theme";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
