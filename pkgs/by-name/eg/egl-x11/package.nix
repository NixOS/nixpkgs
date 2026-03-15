{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  jq,
  libGL,
  libgbm,
  libdrm,
  libx11,
  libxcb,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-x11";
  version = "1.0.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-x11";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sl/qc39H29wXsb5UYKGK7IciwTlbRBqA9omL2sgXpx0=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    jq
  ];

  buildInputs = [
    libGL
    libgbm
    libdrm
    libx11
    libxcb
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
    description = "X11/XCB external platform library";
    homepage = "https://github.com/NVIDIA/egl-x11/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ccicnce113424
    ];
  };
})
