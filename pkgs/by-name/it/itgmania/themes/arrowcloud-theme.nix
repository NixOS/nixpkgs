{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arrowcloud-theme";
  version = "20260424";

  src = fetchFromGitHub {
    owner = "Arrow-Cloud";
    repo = "theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sdl32MARZnPYKN21xoWu8sa6E/lUloMiRrjpWfkXefc=";
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
