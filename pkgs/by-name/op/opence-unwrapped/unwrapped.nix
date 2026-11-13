{
  lib,
  clangStdenv,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  python3,
  runCommand,
  sdl3,
  versionCheckHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "opence-unwrapped";
  version = "343";

  strictDeps = true;
  __structuredAttrs = true;

  env.HALO_BUILD_NUMBER = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "OpenCommunityEdition";
    repo = "OpenCE";
    tag = "build-${finalAttrs.version}";
    hash = "sha256-ifGbx52ru8p7fWM1nT0JNixFaNLDjyKdN1/XWgI1aeE=";
  };

  patches = [ ./extract-xiso.patch ];

  nativeBuildInputs = [
    ninja
    python3
  ];

  buildInputs = [ sdl3 ];

  # The Xbox compatibility header redefines __inline to static inline, which
  # conflicts with the extern inline functions in glibc's fortified headers.
  hardeningDisable = [ "fortify" ];

  postPatch = ''
    # Use the architecture selected by stdenv. Upstream's --portable also
    # downloads a Debian sysroot and builds its own SDL, which we do not need.
    substituteInPlace tools/linux_build.py \
      --replace-fail '"-march=native"' '""' \
      --replace-fail '--target=i686-linux-gnu' '--target=${clangStdenv.hostPlatform.config}'

    # Keep the release number, but let Nix manage updates for clients and servers.
    substituteInPlace port/linux/src/updater.c \
      --replace-fail 'HALO_BUILD_NUMBER <= 0' '1 /* Updates are managed by Nix. */'
  '';

  configurePhase = ''
    runHook preConfigure

    python configure.py --linux-cc "$CC" --release --pgo=off --lto=off

    runHook postConfigure
  '';

  ninjaFlags = [ "linux" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/linux/halo "$out/libexec/opence/halo"
    install -m644 build/linux/{brokers,masters}.txt "$out/libexec/opence/"
    mkdir -p "$out/bin"
    ln -s ../libexec/opence/halo "$out/bin/opence"
    install -Dm644 port/assets/icon/opence-icon-256.png \
      "$out/share/icons/hicolor/256x256/apps/opence.png"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = gitUpdater { rev-prefix = "build-"; };

  meta = {
    description = "Open source port of Halo: Combat Evolved for the original Xbox";
    homepage = "https://github.com/OpenCommunityEdition/OpenCE";
    changelog = "https://github.com/OpenCommunityEdition/OpenCE/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ulysseszhan ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "opence";
  };
})
