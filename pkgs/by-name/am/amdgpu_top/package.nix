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

rustPlatform.buildRustPackage rec {
  pname = "amdgpu_top";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = "amdgpu_top";
    tag = "v${version}";
    hash = "sha256-yw73bKO91O05WBQNwjcQ+AqxYgGXXC7XJzUnMx5/IWc=";
  };

  cargoHash = "sha256-hQrgAyi7740bY5knICWACZhDYoZwPs/dO/PgVC4Krx0=";

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
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/${pname}
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
}
