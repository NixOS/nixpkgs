{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  pkg-config,
  wayland,
  cmake,
  ninja,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microcad";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "microcad";
    repo = "microcad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2164ynL01cLv5/D1FkcZpuBXTHPMjbpeaPPEZpmrSso=";
  };

  cargoHash = "sha256-OwPAl8LirPQEQ8ytx/+9OnrdbUagLA25mGMw1z/L6V0=";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [ wayland ];
  cargoBuildFlags = [
    "-p"
    "microcad-viewer"
    "-p"
    "microcad"
    "-p"
    "microcad-lsp"
  ];

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  meta = {
    description = "Description language for modeling parameterizable geometric objects";
    homepage = "https://microcad.xyz";
    license = lib.licenses.agpl3Plus;
    mainProgram = "microcad";
    donationPage = "https://opencollective.com/microcad/donate";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ fred441a ];
  };
})
