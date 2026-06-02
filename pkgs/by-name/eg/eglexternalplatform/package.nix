{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  buildPackages,
  replaceVars,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eglexternalplatform";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "eglexternalplatform";
    tag = finalAttrs.version;
    hash = "sha256-tDKh1oSnOSG/XztHHYCwg1tDB7M6olOtJ8te+uan9ko=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  setupHook = replaceVars ./setup-hook.sh {
    jq = lib.getExe buildPackages.jq;
    sponge = lib.getExe' buildPackages.moreutils "sponge";
  };

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "EGL External Platform interface";
    homepage = "https://github.com/NVIDIA/eglexternalplatform";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    maintainers = with lib.maintainers; [
      hedning
      ccicnce113424
    ];
  };
})
