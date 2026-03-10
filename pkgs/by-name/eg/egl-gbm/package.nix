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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-gbm";
  version = "1.1.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-gbm";
    tag = finalAttrs.version;
    hash = "sha256-OoHgvFbyd6JakSKyN7N97FMJHNYV1spj7zy3f1g/PN0=";
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
    description = "GBM EGL external platform library";
    homepage = "https://github.com/NVIDIA/egl-gbm/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ccicnce113424
    ];
  };
})
