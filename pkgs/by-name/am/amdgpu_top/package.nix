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
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = "amdgpu_top";
    rev = "v${version}";
    hash = "sha256-9PHMPyL2yg36vG+wax0Lb/LFT7CQWnBnZ+t38hr01PE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W20jtH3w8LVqKwdf2ifwXKO2xgF3e/DuZ8vWqHOAGy0=";

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
