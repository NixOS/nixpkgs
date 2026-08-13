{
  lib,
  stdenv,
  fetchFromGitHub,
  wirelesstools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdk3-master";
  version = "6-unstable-2015-05-24";

  src = fetchFromGitHub {
    owner = "charlesxsh";
    repo = "mdk3-master";
    rev = "1bf2bd31b79560aa99fc42123f70f36a03154b9e";
    hash = "sha256-Jxyv7aoL8l9M7JheazJ+/YqfkDcSNx3ARNhx3G5Y+cM=";
  };

  runtimeDependencies = [ wirelesstools ];

  # fix
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  installPhase = ''
    runHook preInstall
    make -C osdep install
    mkdir -p $out/bin
    install -D -m 0755 mdk3 $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "MDK3 fork able to force reboot Access Points";
    homepage = "https://github.com/charlesxsh/mdk3-master";
    changelog = "https://github.com/charlesxsh/mdk3-master/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "mdk3";
    platforms = lib.platforms.all;
  };
})
