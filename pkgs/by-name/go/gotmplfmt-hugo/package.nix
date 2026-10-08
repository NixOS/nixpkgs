{
  lib,
  buildGoModule,
  fetchFromGitHub,

  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gotmplfmt-hugo";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "gotmplfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z+Qsg0QWWU4+QZrMg61W5bLRm8Ps5b6IsJdUNoYqJFA=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-OEXvKQ/dBxhz6/pbQNDYIjBf3O0x36ZE3Se/FqEgYRg=";

  ldflags = [
    "-s"
    "-X=main.tag=${finalAttrs.src.tag}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.src.tag;
  };

  meta = {
    description = "Format Go templates";
    homepage = "https://github.com/gohugoio/gotmplfmt";
    changelog = "https://github.com/gohugoio/gotmplfmt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "gotmplfmt";
  };
})
