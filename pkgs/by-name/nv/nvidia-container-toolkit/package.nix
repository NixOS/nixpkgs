{
  lib,
  glibc,
  fetchFromGitHub,
  makeWrapper,
  buildGoModule,
  autoAddDriverRunpath,
}:

let
  # From https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L54
  cliVersionPackage = "github.com/NVIDIA/nvidia-container-toolkit/internal/info";
in
buildGoModule (finalAttrs: {
  pname = "nvidia-container-toolkit";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-container-toolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IvjQAYLslNF+tDXnFaoGLISYDq9ieT/W4MVlEWnC8XQ=";

  };

  outputs = [
    "out"
    "tools"
  ];

  vendorHash = null;

  postPatch = ''
    substituteInPlace api/config/v1/config.go \
      --replace-fail '/usr/bin/nvidia-container-runtime-hook' "$tools/bin/nvidia-container-runtime-hook" \
      --replace-fail '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace cmd/nvidia-cdi-hook/update-ldcache/update-ldcache.go \
      --replace-fail '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'
  '';

  subPackages = [
    "cmd/nvidia-cdi-hook"
    "cmd/nvidia-container-runtime"
    "cmd/nvidia-container-runtime.cdi"
    "cmd/nvidia-container-runtime-hook"
    "cmd/nvidia-container-runtime.legacy"
    "cmd/nvidia-ctk"
  ];

  # Based on upstream's Makefile:
  # https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L64
  ldflags = [
    "-extldflags=-Wl,-z,lazy" # May be redunandant, cf. `man ld`: "Lazy binding is the default".
    "-s" # "disable symbol table"

    # "-X name=value"
    "-X ${cliVersionPackage}.version=${finalAttrs.version}"
    "-X ${cliVersionPackage}.gitCommit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    makeWrapper
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable tests executing nvidia-container-runtime command.
        "TestGoodInput"
        "TestDuplicateHook"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mkdir -p $tools/bin
    mv $out/bin/{nvidia-cdi-hook,nvidia-container-runtime,nvidia-container-runtime.cdi,nvidia-container-runtime-hook,nvidia-container-runtime.legacy} $tools/bin
  '';

  meta = {
    homepage = "https://gitlab.com/nvidia/container-toolkit/container-toolkit";
    description = "NVIDIA Container Toolkit";
    mainProgram = "nvidia-ctk";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      cpcloud
      christoph-heiss
    ];
  };
})
