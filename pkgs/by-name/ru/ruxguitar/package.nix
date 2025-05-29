{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  alsa-lib,
  wayland,
  libGL,
  libxkbcommon,
  libgcc,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruxguitar";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "agourlay";
    repo = "ruxguitar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x7/kmWUxE1Z1XY7qr9V08DxJlVJPameOrl4gV2lmiBI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W0CfLyV2YtC5lH0FV37pR5XmkCj/dQMesEXprfdePxI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    wayland
    libGL
    libxkbcommon
    libgcc
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  # Auto patchelf won't work because winit loads wayland shared libraries with dlopen
  postFixup = ''
    patchelf $out/bin/ruxguitar --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

  meta = {
    mainProgram = "ruxguitar";
    description = "Guitar Pro tablature player";
    homepage = "https://github.com/agourlay/ruxguitar";
    changelog = "https://github.com/agourlay/ruxguitar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
