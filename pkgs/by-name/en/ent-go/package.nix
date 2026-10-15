{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  installShellFiles,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "ent-go";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pkD8MYyinvuKCtSpHGfFE9y8GRP40qdeyjhB32yeiK4=";
  };

  vendorHash = "sha256-FpyDGBT5uu2ibYz9grjmyHjP5GiOAKpnqLW90zf1OE4=";

  patches = [
    # go1.27 support (x/tools update), remove with the next release
    (fetchpatch2 {
      url = "https://github.com/ent/ent/commit/8037bc89bcab9a264099afa2672581237a3e079b.patch?full_index=1";
      hash = "sha256-kTFpsHftoatf0EIPf4HOSttXiTgZWROd0eVdeNnLjAY=";
      includes = [
        "go.mod"
        "go.sum"
        "dialect/sql/schema/atlas.go"
        "cmd/internal/base/packages_test.go"
      ];
    })
    # patch in version information so we don't get "version = "(devel)";"
    (replaceVars ./ent_version.patch {
      inherit (finalAttrs) version;
      sum = finalAttrs.src.outputHash;
    })
  ];

  subPackages = [ "cmd/ent" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ent \
      --bash <($out/bin/ent completion bash) \
      --fish <($out/bin/ent completion fish) \
      --zsh <($out/bin/ent completion zsh)
  '';

  meta = {
    description = "Entity framework for Go";
    homepage = "https://entgo.io/";
    changelog = "https://github.com/ent/ent/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/ent/ent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "ent";
  };
})
