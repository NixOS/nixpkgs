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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eXUeXBFW2ejkOeMUujMwY0gidzdaX9yWWOfx1ZwA3lk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-t8lnwq4V81OwtT9AVL2JLM6ZbcWKRdyY2bjwZ6y6Suk=";

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
