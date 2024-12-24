{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  zig_0_13,
  apple-sdk_11,
  callPackage,
}:

let
  zig = zig_0_13;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linuxwave";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "linuxwave";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mPBtffqd0+B7J8FxolzOarCyJIZBWkWPBbqZlhX0VSY=";
  };

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    installShellFiles
    zig.hook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  postInstall = ''
    installManPage man/linuxwave.1
  '';

  meta = {
    homepage = "https://github.com/orhun/linuxwave";
    description = "Generate music from the entropy of Linux";
    changelog = "https://github.com/orhun/linuxwave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    inherit (zig.meta) platforms;
    mainProgram = "linuxwave";
  };
})
