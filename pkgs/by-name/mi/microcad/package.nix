{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  wayland,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microcad";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "microcad";
    repo = "microcad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v4cvt2IjkJkp4VKZ8w/2m5tOOfYXjPxq1y6vxNwOtDA=";
  };

  cargoHash = "sha256-arPCdWRdPju5AfxH8u1td8V7hrzWSCfIDnJ2JsCW00w=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ wayland ];
  cargoBuildFlags = [
    "-p"
    "microcad-viewer"
    "-p"
    "microcad"
    "-p"
    "microcad-lsp"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Description language for modeling parameterizable geometric objects";
    homepage = "https://microcad.xyz";
    license = lib.licenses.agpl3Plus;
    mainProgram = "microcad";
    donationPage = "https://opencollective.com/microcad/donate";
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fred441a ];
  };
})
