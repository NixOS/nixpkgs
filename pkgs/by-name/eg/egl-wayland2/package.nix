{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  jq,
  libGL,
  libgbm,
  libdrm,
  wayland,
  wayland-protocols,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland2";
  version = "1.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Udr+tihx/Si2ynFyM1FW2CIUgTg9SQn7AgrOPpGTxpY=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    jq
  ];

  buildInputs = [
    libGL
    libgbm
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  postFixup = ''
    pushd $out/share/egl/egl_external_platform.d
    for f in *.json; do
      jq --arg lib "$out" \
        '.ICD.library_path |= $lib + "/lib/" + .' \
        "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    done
    popd
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      vancluever
      ccicnce113424
    ];
  };
})
