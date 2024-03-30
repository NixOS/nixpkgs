{ lib
, gitSupport ? true
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pandoc
, pkg-config
, zlib
, darwin
, libiconv
, installShellFiles
  # once eza upstream gets support for setting up a compatibilty symlink for exa, we should change
  # the handling here from postInstall to passing the required argument to the builder.
, exaAlias ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "eza";
  version = "0.18.9";

  src = fetchFromGitHub {
    owner = "eza-community";
    repo = "eza";
    rev = "v${version}";
    hash = "sha256-SXGJTxTHCizgVBLp5fO5Appfe1B3+DFrobxc/aIlJRo=";
  };

  cargoHash = "sha256-COq1WSX7DUoXb7ojISyzmDV/a3zqXI0oKCSsPPi4/CA=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles pandoc ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = [ "out" "man" ];

  postInstall = ''
    pandoc --standalone -f markdown -t man man/eza.1.md > man/eza.1
    pandoc --standalone -f markdown -t man man/eza_colors.5.md > man/eza_colors.5
    pandoc --standalone -f markdown -t man man/eza_colors-explanation.5.md > man/eza_colors-explanation.5
    installManPage man/eza.1 man/eza_colors.5 man/eza_colors-explanation.5
    installShellCompletion \
      --bash completions/bash/eza \
      --fish completions/fish/eza.fish \
      --zsh completions/zsh/_eza
  '' + lib.optionalString exaAlias ''
    ln -s eza $out/bin/exa
  '';

  meta = with lib; {
    description = "A modern, maintained replacement for ls";
    longDescription = ''
      eza is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. eza is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = "https://github.com/eza-community/eza";
    changelog = "https://github.com/eza-community/eza/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "eza";
    maintainers = with maintainers; [ cafkafk _9glenda ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
