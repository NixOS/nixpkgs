{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  makeWrapper,
  pkg-config,
  python3,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libXxf86vm,
  libxcb,
  libxkbcommon,
  wayland,
}:
let
  rpathLibs = [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libxcb
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "emulsion";
  version = "11.0";

  src = fetchFromGitHub {
    owner = "ArturKovacs";
    repo = "emulsion";
    rev = "v${version}";
    sha256 = "sha256-0t+MUZu1cvkJSL9Ly9kblH8fMr05KuRpOo+JDn/VUc8=";
  };

  cargoHash = "sha256-1s5kCUxn4t1A40QHuygGKaqphLmcl+EYfx++RZQmL00=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = rpathLibs;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/emulsion
  '';

  meta = with lib; {
    description = "Fast and minimalistic image viewer";
    homepage = "https://arturkovacs.github.io/emulsion-website/";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "emulsion";
  };
}
