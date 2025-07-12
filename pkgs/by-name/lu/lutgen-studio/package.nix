{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,

  fontconfig,
  libGL,
  libxkbcommon,
  openssl,
  wayland,
  xorg,
  zenity,

  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen-studio";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "${pname}-v${version}";
    hash = "sha256-Gv64Z4OiC/GrDOuKWiPwDEqjCpwzD4k+f46EQwKWbI0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8A8eviGtwVd9Ve04vKa5JH6x7M1qS7slS9QwP+hisVc=";

  cargoBuildFlags = [
    "--bin"
    "${pname}"
  ];
  cargoTestFlags = [
    "-p"
    "${pname}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # Include dynamically loaded libraries
  LD_LIBRARY_PATH = "${lib.makeLibraryPath ([
    fontconfig
    libGL
    libxkbcommon
    openssl
    wayland
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ])}";

  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}" \
      --set PATH "${zenity}/bin"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^${pname}-v([0-9.]+)$" ];
  };

  meta = with lib; {
    description = "Offical GUI for Lutgen, the best way to apply popular colorschemes to any image or wallpaper";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [ ozwaldorf ];
    mainProgram = "${pname}";
    license = licenses.mit;
  };
}
