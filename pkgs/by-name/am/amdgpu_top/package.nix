{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libdrm,
  libx11,
  libGL,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libxrandr,
  libxi,
  libxcursor,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amdgpu_top";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = "amdgpu_top";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ap1X53Ou/eWhHvXOnHY7zGb6i+ZLs8LeSNpOJWm+IKc=";
  };

  cargoHash = "sha256-b9OO//9M/LyS4ZMQzppvLHJHL3JyPVoSOIPVlrX1Wes=";

  buildInputs = [
    libdrm
    libx11
    libGL
    wayland
    wayland-protocols
    libxkbcommon
    libxrandr
    libxi
    libxcursor
  ];

  postInstall = ''
    install -D ./assets/amdgpu_top.desktop -t $out/share/applications/
    install -D ./assets/amdgpu_top-tui.desktop -t $out/share/applications/
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}" $out/bin/${finalAttrs.meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to display AMDGPU usage";
    homepage = "https://github.com/Umio-Yasuno/amdgpu_top";
    changelog = "https://github.com/Umio-Yasuno/amdgpu_top/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      geri1701
      Gliczy
    ];
    platforms = lib.platforms.linux;
    mainProgram = "amdgpu_top";
  };
})
