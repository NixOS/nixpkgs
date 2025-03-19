{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libdrm,
  libX11,
  libGL,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libXrandr,
  libXi,
  libXcursor,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "amdgpu_top";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = "amdgpu_top";
    rev = "v${version}";
    hash = "sha256-OvxrcVjngIW/fVIPX1XhbGImAeDifoLzlaZpXUYS9FA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-na6pghbJ7Ek+rdbX4qJt2kv7C3AAqpgU/nYHaT9CQdo=";

  buildInputs = [
    libdrm
    libX11
    libGL
    wayland
    wayland-protocols
    libxkbcommon
    libXrandr
    libXi
    libXcursor
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
