{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  flex,
  bison,
  bc,
  cpio,
  perl,
  elfutils,
  python3,
  nix-update-script,
  writeShellScript,
  _experimental-update-script-combinators,
  variant ? null,
}:

assert lib.elem variant [
  null
  "sev"
  "tdx"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw" + lib.optionalString (variant != null) "-${variant}";
  version = "5.6.4";
  kernelVersion = "6.12.115";

  kernelSrc = fetchurl {
    url = "https://github.com/libkrun/linux/archive/refs/tags/v${finalAttrs.version}-${finalAttrs.kernelVersion}.tar.gz";
    hash = "sha256-BQ/OqWtgfknxNfJwRyvJU0bBcsnW31+SVq6295cmddU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "libkrun";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jf8z5dIVIiE5YFElolDxij3k8c8nBeDPhnnCiuhb0YE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'curl -L $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s ${finalAttrs.kernelSrc} $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    cpio
    perl
    python3
    python3.pkgs.pyelftools
  ];

  buildInputs = [
    elfutils
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (variant == "sev") [
    "SEV=1"
  ]
  ++ lib.optionals (variant == "tdx") [
    "TDX=1"
  ];

  # Fixes https://github.com/containers/libkrunfw/issues/55
  env = lib.optionalAttrs stdenv.targetPlatform.isAarch64 {
    NIX_CFLAGS_COMPILE = "-march=armv8-a+crypto";
  };

  enableParallelBuilding = true;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { extraArgs = [ "--src-only" ]; })
    (writeShellScript "update-libkrun-kernel" ''
      set -eou pipefail

      src="$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH.src")"
      kver="$(sed -n 's/^KERNEL_VERSION = //p' "$src/Makefile")"
      sed -i "s/kernelVersion = \".*\";/kernelVersion = \"$kver\";/" "pkgs/by-name/li/libkrunfw/package.nix"
    '')
    (nix-update-script {
      extraArgs = [
        "--version=skip"
        "--custom-dep"
        "kernelSrc"
      ];
    })
  ];

  meta = {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/libkrun/libkrunfw";
    license = with lib.licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optionals (variant == null) [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };
})
