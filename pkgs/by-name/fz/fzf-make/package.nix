{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  oniguruma,
  versionCheckHook,
  runtimeShell,
  bat,
  gnugrep,
  gnumake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fzf-make";
  version = "0.76.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7PchjXqrN8N2uLnxxl9weHE9Q7xNo+6+FAr9iTW+63A=";
  };

  cargoHash = "sha256-W0DAhQC9Fe4Tk+9mMZrIBQRyVhHSUHWg51LHSJ/h2HA=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [ oniguruma ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${
        lib.makeBinPath [
          bat
          gnugrep
          gnumake
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fuzzy finder for Makefile";
    homepage = "https://github.com/kyu08/fzf-make";
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmanificient
    ];
    mainProgram = "fzf-make";
  };
})
