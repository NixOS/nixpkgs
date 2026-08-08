{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  gitMinimal,
  cmake,
  installShellFiles,
  python3,
}:
let
  target = stdenv.hostPlatform.rust.cargoShortTarget;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bender";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "bender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pyx68NTlCNTGKXdEGG9YML5E+vJlLHlPQjjbSV2uOsE=";
  };

  cargoHash = "sha256-XItTYqTTN8KBvyFmDSKIgVURox/1tmAFjDAM8Vq3zxo=";

  patches = [
    (replaceVars ./build-rs.patch {
      # We will download them instead of cmake's fetchContent
      #
      # We manually build the dependencies as
      # bender-slang builds slang as a private cmake dependency with specific
      # compile-time defines (SLANG_USE_MIMALLOC, SLANG_BOOST_SINGLE_HEADER, etc.)
      # that must match between the library and the cxx bridge to avoid ABI
      # incompatibilities.
      slangSrc = fetchFromGitHub {
        owner = "MikePopoloski";
        repo = "slang";
        tag = "v11.0";
        hash = "sha256-popHzwX0qwv2POAl7/qX3e//OwJRXGtSl9xogpSn2LI=";
      };

      fmtSrc = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        tag = "12.1.0";
        hash = "sha256-ZmI1Dv0ZabPlxa02OpERI47jp7zFfjpeWCy1WyuPYZ0=";
      };

      mimallocSrc = fetchFromGitHub {
        owner = "microsoft";
        repo = "mimalloc";
        tag = "v3.3.2";
        hash = "sha256-GZ37qQVDe9jgMb4Coe5oKvgaLTspZDlSkS5rdy1MfUU=";
      };
    })
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    python3
  ];

  # owo-colors wraps test assertions in ANSI codes when TERM is set,
  # causing string-matching tests to fail in the sandbox.
  preCheck = "export NO_COLOR=1";

  nativeCheckInputs = [ gitMinimal ];
  postCheck = ''
    patchShebangs --build tests
    BENDER="$PWD/target/${target}/$cargoBuildType/bender" tests/run_all.sh
  '';

  postInstall = ''
    installShellCompletion --cmd bender \
      --bash <($out/bin/bender completion bash) \
      --fish <($out/bin/bender completion fish) \
      --zsh <($out/bin/bender completion zsh)
  '';

  meta = {
    description = "Dependency management tool for hardware projects";
    homepage = "https://github.com/pulp-platform/bender";
    changelog = "https://github.com/pulp-platform/bender/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Liamolucko ];
    mainProgram = "bender";
    platforms = lib.platforms.all;
  };
})
