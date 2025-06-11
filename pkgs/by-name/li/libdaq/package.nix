{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libpcap,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdaq";
  version = "3.0.19";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "libdaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ma+M/rIbChqL0pjhE0a1UfJLm/r7I7IvIuSwcnQWvAQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libpcap
    stdenv.cc.cc # libstdc++
  ];

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  autoreconfPhase = ''
    ./bootstrap
  '';

  postInstall = ''
    # remove build directory (/build/**, or /tmp/nix-build-**) from RPATHs
    for f in "$out"/bin/*; do
      local nrp="$(patchelf --print-rpath "$f" | sed -E 's@(:|^)'$NIX_BUILD_TOP'[^:]*:@\1@g')"
      patchelf --set-rpath "$nrp" "$f"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Data AcQuisition library (libDAQ), for snort packet I/O";
    homepage = "https://www.snort.org";
    maintainers = with lib.maintainers; [
      aycanirican
      brianmcgillion
    ];
    changelog = "https://github.com/snort3/libdaq/releases/tag/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2;
    outputsToInstall = [
      "lib"
      "dev"
    ];
    platforms = with lib.platforms; linux;
  };
})
