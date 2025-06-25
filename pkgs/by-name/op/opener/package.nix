{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "opener";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "superbrothers";
    repo = "opener";
    tag = "v${version}";
    hash = "sha256-rYeQ45skFXWxdxMj0dye8IBEYcQCRqdt9nLVXF36od8=";
  };

  vendorHash = "sha256-lju+QlWxUb11UV9NvXSgQ+ZG37WhyZVahJTM5voDEfw=";

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
