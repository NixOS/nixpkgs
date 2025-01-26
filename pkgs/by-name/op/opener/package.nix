{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "opener";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "superbrothers";
    repo = "opener";
    tag = "v${version}";
    hash = "sha256-pp2jn4J6gYyZky5rVBaai9sVVqvPgM+fGryseM58WEI=";
  };

  vendorHash = "sha256-xwMRWEwrG12QevVVTMC9OTdjIBoxR1AHkoa6OErPpF4=";

  postPatch = ''
    substituteInPlace opener.go \
      --replace-fail \
        'var version string' \
        'var version string = "${version}"'
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open URL in your local web browser from the SSH-connected remote environment";
    homepage = "https://github.com/superbrothers/opener";
    changelog = "https://github.com/superbrothers/opener/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "opener";
  };
}
