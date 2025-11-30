{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  zig_0_14,
  callPackage,
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

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    installShellFiles
    zig.hook
  ];

  postInstall = ''
    installManPage man/linuxwave.1
  '';

  meta = {
    homepage = "https://github.com/orhun/linuxwave";
    description = "Generate music from the entropy of Linux";
    changelog = "https://github.com/orhun/linuxwave/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    inherit (zig.meta) platforms;
    mainProgram = "linuxwave";
  };
})
