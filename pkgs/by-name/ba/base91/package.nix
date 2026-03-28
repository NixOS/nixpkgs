{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "base91";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    rev = "v${version}";
    hash = "sha256-S5gWC2SmN5lAjfFGK0z31ZL//pRXQG2qLk3RMnzuiys=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-Xxph31cpLJjHA3EzU0541FM0IIkCTA9HHpWM8IiXHkQ=";

  cargoExtraArgs = "-p base91-cli";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s base91 $out/bin/b91enc
    ln -s base91 $out/bin/b91dec

    out_dir=$(find . -path "*/build/base91-cli-*/out" -maxdepth 6 | head -1)
    if [ -n "$out_dir" ]; then
      install -Dm444 "$out_dir/base91.1" $out/share/man/man1/base91.1
      installShellCompletion --cmd base91 \
        --bash "$out_dir/base91.bash" \
        --zsh "$out_dir/_base91" \
        --fish "$out_dir/base91.fish"
    fi
  '';

  meta = {
    description = "basE91 binary-to-text encoder/decoder";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "base91";
    platforms = lib.platforms.unix;
  };
}
