{
  stdenv,
  fetchFromGitHub,
  flock,
  gitUpdater,
  bashInteractive,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enroot";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "enroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uaUtDdAqqniH+fFCgUZ9Ed75Fq0X2pvVJcFeyGHtdVM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'git submodule update' 'echo git submodule update'
  '';

  makeTarget = "install";
  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix=/"
  ];

  nativeBuildInputs = [
    flock
  ];

  buildInputs = [
    bashInteractive
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Simple yet powerful tool to turn traditional container/OS images into unprivileged sandboxes";
    license = lib.licenses.asl20;
    homepage = "https://github.com/NVIDIA/enroot";
    changelog = "https://github.com/NVIDIA/enroot/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "enroot";
  };
})
