{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  oniguruma,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-igitt";
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "git-bahn";
    repo = "git-igitt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3heVYUe9bAApkZVMM0uAj54X6Hx0lvs7sx4bIJ0elJw=";
  };

  cargoHash = "sha256-0LH7CVeXxyRXcyCS5NZ0b5Gst5AHsF/4wF7hcOppNxI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    oniguruma
    zlib
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive, cross-platform Git terminal application with clear git graphs arranged for your branching model";
    homepage = "https://github.com/git-bahn/git-igitt";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      pinage404
    ];
    mainProgram = "git-igitt";
  };
})
