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
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "agourlay";
    repo = "ruxguitar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2sLWUQ+4qlgQkKV6L5++ydyyNgab6Cfp/QNcFNHV3O4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fPdS00VroZuPb+DwkarO94JE7LQuIpvGQuDt+8bfkeA=";

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
