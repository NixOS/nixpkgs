{
  cmake,
  fetchFromGitHub,
  lib,
  nasm,
  perl,
  qemu,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rimage";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "SalOne22";
    repo = "rimage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I7nOvxRORdZeolBABt5u94Ij0PI/AiLi4wbN+C02haQ=";
  };

  auditable = false;

  cargoHash = "sha256-kfOzzVkxHDqVrhX6vZF18f9hAXK9SKwezJphH0QGE4E=";

  nativeBuildInputs = [
    cmake
    nasm
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qemu
  ];

  cargoBuildFlags = [ "--bin=rimage" ];

  buildFeatures = [
    "build-binary"
    "icc"
  ];

  patches = [
    # The below patch is needed to fix this build, until the upstream dependency (libavif-rs) fixes the problem.
    # The explicit `patchFlags` can also be removed when this patch becomes obsolete.
    # <https://github.com/njaard/libavif-rs/issues/122>
    ./libaom-sys-0.17.2+libaom.3.11.0-cmake-nasm-fix.patch
  ];

  patchFlags = [
    "-p1"
    "--directory=../rimage-${finalAttrs.version}-vendor"
  ];

  meta = {
    description = "Rust image optimization CLI tool inspired by squoosh";
    homepage = "https://github.com/SalOne22/rimage";
    changelog = "https://github.com/SalOne22/rimage/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dustypomerleau ];
    mainProgram = "rimage";
  };
})
