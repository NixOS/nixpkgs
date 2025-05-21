{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  callPackage,
}:
buildGoModule (finalAttrs: {
  pname = "reddit-tui";
  version = "0.3.6";
  src = fetchFromGitHub {
    owner = "tonymajestro";
    repo = "reddit-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5S5wEPoVqYxIIEBXlrP5a+0xF66n6FMWkH0iTdIxioo=";
  };
  vendorHash = "sha256-Yqo80adzA9gtSD3qzM+fObzRt3WbcMATQef0g7/z2Dw=";
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/tonymajestro/reddit-tui/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/tonymajestro/reddit-tui";
    description = "Terminal UI for reddit";
    longDescription = ''
      Due to suspected throttling by reddit, it might be necessary to use a [redlib backend](https://github.com/redlib-org/redlib) to enable this package to work.
      See [the Docs](https://github.com/tonymajestro/reddit-tui#configuration-files) on how to do that.
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.LazilyStableProton ];
    mainProgram = "reddittui";
  };
})
