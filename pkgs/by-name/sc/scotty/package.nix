{
  lib,
  stdenv,
  buildGoModule,
  fetchFromSourcehut,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "scotty";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~phw";
    repo = "scotty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sf1JuIWCscHPn7bA7spQ1zTKt+1kEehR+rEZ1+MTnoE=";
  };

  # Otherwise checks fail with `panic: open /etc/protocols: operation not permitted` when sandboxing is enabled on Darwin
  # https://github.com/NixOS/nixpkgs/pull/381645#issuecomment-2656211797
  modPostBuild = ''
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  vendorHash = "sha256-AfCSp/f8jAy1a6PyYHMErmOOgADXTfliJPQgyNLhVFo=";

  env = {
    # *Some* locale is required to be set
    # https://git.sr.ht/~phw/scotty/tree/04eddfda33cc6f0b87dc0fcea43d5c4f50923ddc/item/internal/i18n/i18n.go#L30
    LC_ALL = "C.UTF-8";
  };

  passthru = {
    tests.version = testers.testVersion {
      # See above
      command = "LC_ALL='C.UTF-8' scotty --version";
      package = finalAttrs.finalPackage;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Transfers your listens between various music listen tracking and streaming services";
    homepage = "https://git.sr.ht/~phw/scotty";
    changelog = "https://git.sr.ht/~phw/scotty/refs/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "scotty";
  };
})
