{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arrowcloud-theme";
  version = "20260525";

  src = fetchFromGitHub {
    owner = "Arrow-Cloud";
    repo = "theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HrvDJ5bxVDge6SvUjFwBjy15H9sUHeKiwCX9biPw338=";
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
