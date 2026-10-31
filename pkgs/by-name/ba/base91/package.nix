{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "base91";
  version = "0.3.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1v/kvv+IUoYmrs6MrBmnA4UYIRjN4KICW/Q0zaiiGq0=";
  };

  cargoRoot = "rust";
  buildAndTestSubdir = "rust/base91-cli";

  cargoHash = "sha256-5ubqTQQz0OBZoe3Ql/e1H5S1cL1EhYVabcZ9FkfQzao=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s base91 $out/bin/b91enc
    ln -s base91 $out/bin/b91dec
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/base91 --man > base91.1
    installManPage base91.1
    ln -s base91.1 $out/share/man/man1/b91enc.1
    ln -s base91.1 $out/share/man/man1/b91dec.1
    installShellCompletion --cmd base91 \
      --bash <($out/bin/base91 --completions bash) \
      --zsh <($out/bin/base91 --completions zsh) \
      --fish <($out/bin/base91 --completions fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Binary-to-text encoder and decoder for the basE91 format";
    longDescription = ''
      base91 encodes binary data as printable ASCII with about 23% overhead
      (base64: 33%). It reads and writes Joachim Henke's basE91 format, as
      the original C tool does. It also offers a fixed-width variant of the
      format (--simd), designed for SIMD instructions: with SSE4.1, AVX2 or
      NEON, it encodes and decodes at several GiB/s. b91enc and b91dec are
      the encoder and decoder under their traditional names.
    '';
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "base91";
    platforms = lib.platforms.unix;
  };
})
