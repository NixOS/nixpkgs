{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  testers,
  nix-update-script,
  go-md2man,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "angrr";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "angrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XsFuvWur9KaZaIT4IkgiXRtom/Hcn6xnJt8lbvpYu94=";
  };

  cargoHash = "sha256-QZxEVHd1RoN7Qxouj5cScvbK6Y0FLMH3zXKr07/Cyes=";

  buildAndTestSubdir = "angrr";

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];
  postBuild = ''
    mkdir --parents build/{man-pages,shell-completions}
    cargo xtask man-pages --out build/man-pages
    cargo xtask shell-completions --out build/shell-completions
  '';
  postInstall = ''
    install -m400 -D ./direnv/angrr.sh $out/share/direnv/lib/angrr.sh
    installManPage build/man-pages/*
    installShellCompletion --cmd angrr \
      --bash build/shell-completions/angrr.bash \
      --fish build/shell-completions/angrr.fish \
      --zsh  build/shell-completions/_angrr
  '';

  passthru = {
    tests = {
      module = nixosTests.angrr;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Auto Nix GC Root Retention";
    homepage = "https://github.com/linyinfeng/angrr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yinfeng ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "angrr";
  };
})
