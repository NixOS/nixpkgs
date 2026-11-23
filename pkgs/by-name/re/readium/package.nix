{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "readium";
  version = "0.11.0";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "readium";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SBc/1lHZWOoudr43U+WIqqjKBHhBN5jm3zqF5wCNE8=";
  };

  vendorHash = "sha256-0DaRZAk38fGHmPskNt/ocCerNEJ0UXB6rWQ4SH3ukVk=";

  ldflags = [ "-X=github.com/readium/cli/internal/version.Version=v${finalAttrs.version}" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/readium
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI utility with support for a wide range of commands for ebooks, comics and audiobooks";
    homepage = "https://github.com/readium/cli/";
    changelog = "https://github.com/readium/cli/blob/develop/CHANGELOG.MD";
    license = lib.licenses.bsd3;
    mainProgram = "readium";
    maintainers = with lib.maintainers; [ CodeF53 ];
  };
})
