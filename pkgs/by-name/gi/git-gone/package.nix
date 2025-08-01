{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  asciidoctor,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    tag = "v${version}";
    hash = "sha256-4BhFombZCmv/GNG2OcNlWNKTk2h65yKn1ku734gCBCQ=";
  };

  # remove if updating to rust 1.85
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'
  '';

  cargoHash = "sha256-VjnnrVN+uST99paImI1uNj34CNozid7ZiPslJqvmKCs=";

  # remove if updating to rust 1.85
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];

  postInstall = ''
    asciidoctor --backend=manpage git-gone.1.adoc -o git-gone.1
    installManPage git-gone.1
  '';

  meta = {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://github.com/swsnr/git-gone";
    changelog = "https://github.com/swsnr/git-gone/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-gone";
  };
}
