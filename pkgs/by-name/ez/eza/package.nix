{
  lib,
  gitSupport ? true,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pandoc,
  pkg-config,
  zlib,
  installShellFiles,
  # once eza upstream gets support for setting up a compatibility symlink for exa, we should change
  # the handling here from postInstall to passing the required argument to the builder.
  exaAlias ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eza";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "eza-community";
    repo = "eza";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zLb2VPfmv9J9UdPAXS+QPHI+hvDRl5UBcvW84J6nUK8=";
  };

  cargoHash = "sha256-3KLjlEZhGEyOcaiBnfIafR509oRbsWllqf1e6Z0M8Sg=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
    pandoc
  ];
  buildInputs = [ zlib ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    for page in eza.1 eza_colors.5 eza_colors-explanation.5; do
      sed "s/\$version/v${finalAttrs.version}/g" "man/$page.md" |
        pandoc --standalone -f markdown -t man >"man/$page"
    done
    installManPage man/eza.1 man/eza_colors.5 man/eza_colors-explanation.5
    installShellCompletion \
      --bash completions/bash/eza \
      --fish completions/fish/eza.fish \
      --zsh completions/zsh/_eza
  ''
  + lib.optionalString exaAlias ''
    ln -s eza $out/bin/exa
  '';

  meta = {
    description = "Modern, maintained replacement for ls";
    longDescription = ''
      eza is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. eza is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = "https://github.com/eza-community/eza";
    changelog = "https://github.com/eza-community/eza/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.eupl12;
    mainProgram = "eza";
    maintainers = with lib.maintainers; [
      cafkafk
      _9glenda
      sigmasquadron
    ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
