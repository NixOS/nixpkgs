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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1OPaQcjrUaYTvMrOPcTemGs8DPn3NuuIbaIObxLiCt0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libdrm_amdgpu_sys-0.7.7" = "sha256-gPK3BrW2oTCQDRvHJGY28EFmkKrVexY2bGXG2QwHZL0=";
    };
  };

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
    install -D ./assets/${pname}.desktop -t $out/share/applications/
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
    maintainers = with lib.maintainers; [ geri1701 ];
    platforms = lib.platforms.linux;
    mainProgram = "amdgpu_top";
  };
}
