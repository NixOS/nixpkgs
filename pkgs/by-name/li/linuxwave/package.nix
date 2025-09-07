{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  zig_0_14,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linuxwave";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "linuxwave";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OuD5U/T3GuCQrzdhx01NXPSXD7pUAvLnNsznttJogz8=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig.hook
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZpDmHTuWaMip8JQKv5O67+OyHKZHk5pFmxs+eqhLFao=";
  };

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
