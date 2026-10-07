{
  lib,
  rustPlatform,
  fetchCrate,
  libxml2,
  ncurses,
  zlib,
  features ? [
    "use_jemalloc"
    "allow_avx2"
    "unstable"
  ],
}:
# Don't allow LLVM support until https://github.com/ezrosent/frawk/issues/115 is resolved.
assert lib.assertMsg (
  !(lib.elem "default" features || lib.elem "llvm_backend" features)
) "LLVM support has been dropped due to LLVM 12 EOL.";
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frawk";
  version = "0.4.8";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-wPnMJDx3aF1Slx5pjLfii366pgNU3FJBdznQLuUboYA=";
  };

  cargoHash = "sha256-VraFR3Mp4mPh+39hw88R0q1p5iNkcQzvhRVNPwSxzU0=";

  patches = [
    # Remove these two patches after frawk is updated to a version including this fix
    # This patch comes from https://github.com/ezrosent/frawk/pull/120
    ./fix-some-compiler-warnings-errors.patch
    # From https://github.com/ezrosent/frawk/commit/35a79dc04933f38f98a7c8f6fc89ca09724702ab
    ./fix-prefetch-read-data.patch
  ];

  buildInputs = [
    libxml2
    ncurses
    zlib
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = features;

  preBuild = lib.optionalString (lib.elem "default" features || lib.elem "unstable" features) ''
    export RUSTC_BOOTSTRAP=1
  '';

  # depends on cpu instructions that may not be available on builders
  doCheck = false;

  meta = {
    description = "Small programming language for writing short programs processing textual data";
    mainProgram = "frawk";
    homepage = "https://github.com/ezrosent/frawk";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ ];
  };
})
