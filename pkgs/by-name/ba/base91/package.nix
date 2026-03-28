{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "base91";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aul68hDvEriSOUAutJkboeP7rzLcZGC7va39GVqKmig=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-X9hVLZ5+oVsPWihOxaAQQMLOJhejNBQnRQgdk1sp3Lw=";

  cargoExtraArgs = "-p base91-cli";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s base91 $out/bin/b91enc
    ln -s base91 $out/bin/b91dec

    out_dir=$(find . -maxdepth 6 -path "*/build/base91-cli-*/out" | head -1)
    if [ -z "$out_dir" ]; then
      echo "base91: could not locate cargo OUT_DIR" >&2
      exit 1
    fi
    install -Dm444 "$out_dir/base91.1" $out/share/man/man1/base91.1
    installShellCompletion --cmd base91 \
      --bash "$out_dir/base91.bash" \
      --zsh "$out_dir/_base91" \
      --fish "$out_dir/base91.fish"
  '';

  meta = {
    description = "basE91 binary-to-text encoder/decoder";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "base91";
    platforms = lib.platforms.unix;
  };
})
