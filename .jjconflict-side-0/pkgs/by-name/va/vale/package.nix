{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  symlinkJoin,
  versionCheckHook,
  valeStyles,
}:

buildGoModule (finalAttrs: {
  pname = "vale";
  version = "3.25.1";

  subPackages = [ "cmd/vale" ];

  src = fetchFromGitHub {
    owner = "vale-cli";
    repo = "vale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ko+7JkwtnHmNdaeAq0LOjJMrUptbvOzDtGHET9xYSvE=";
  };

  # go mod vendor prunes go-tree-sitter/php/tree_sitter/ because it is
  # headers-only. see https://github.com/golang/go/issues/26366
  proxyVendor = true;
  vendorHash = "sha256-cuSjULIbb7JtP0CkX4eFm9RChi3nQW46k5Ik9DyGYKk=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require network access
  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.withStyles =
    selector:
    symlinkJoin {
      name = "vale-with-styles-${finalAttrs.version}";
      paths = [ finalAttrs.finalPackage ] ++ selector valeStyles;
      nativeBuildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/vale" \
          --set VALE_STYLES_PATH "$out/share/vale/styles/"
      '';
      meta.mainProgram = finalAttrs.meta.mainProgram;
    };

  meta = {
    description = "Syntax-aware linter for prose built with speed and extensibility in mind";
    longDescription = ''
      Vale in Nixpkgs offers the helper `.withStyles` allow you to install it
      predefined styles:

      ```nix
      vale.withStyles (s: [ s.alex s.google ])
      ```
    '';
    homepage = "https://vale.sh/";
    changelog = "https://github.com/vale-cli/vale/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "vale";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
