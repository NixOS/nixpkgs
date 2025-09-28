{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  pkg-config,
  cmake,
  fontconfig,
  libGL,
  xorg,
  libxkbcommon,
  wayland,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-lsp";
  version = "1.13.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-XEs7zJWocRZgVPPDM/IxOOwE7ofh+b7A/TJrQw/mMOo=";
  };

  cargoHash = "sha256-DAoqfnis95oEPBgYeOdR3zUVdoKbay780iJ6zVkxdDU=";

  rpathLibs = [
    fontconfig
    libGL
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    fontconfig
  ];
  buildInputs = finalAttrs.rpathLibs ++ [ xorg.libxcb.dev ];

  # Tests requires `i_slint_backend_testing` which is only a dev dependency
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.rpathLibs} $out/bin/slint-lsp
  '';

  dontPatchELF = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server Protocol (LSP) for Slint UI language";
    mainProgram = "slint-lsp";
    homepage = "https://slint-ui.com/";
    downloadPage = "https://github.com/slint-ui/slint/";
    changelog = "https://github.com/slint-ui/slint/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ xgroleau ];
  };
})
