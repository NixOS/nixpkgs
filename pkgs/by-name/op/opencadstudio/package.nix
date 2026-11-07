{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  desktopToDarwinBundle,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencadstudio";
  version = "2026.44";
  src = fetchFromGitHub {
    owner = "HakanSeven12";
    repo = "OpenCADStudio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tOCbx1LxgGq20Uk6Gx4EAVsXTGDwEK0x1hlAsscDLSI=";
  };

  cargoHash = "sha256-C+T6TJHs28b0RyX4x5Tw0iKPC9Pzeo063MNfel6vBCs=";

  __structuredAttrs = true;
  # to test local http api (app::control::http_bridge::*)
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  cargoBuildFlags = [
    "--bin"
    "OpenCADStudio"
  ];

  doCheck = true;
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin (
    lib.forEach [
      # panicked at src/sysinfo.rs:222:9: installed RAM should be readable
      "sysinfo::tests::host_facts_are_never_empty"
    ] (test: "--skip=${test}")
  );

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/{apps,mimetypes}

    install -D --mode=0444 packaging/io.github.HakanSeven12.OpenCadStudio.metainfo.xml \
      -t $out/share/metadata

    install -D --mode=0444 assets/logo.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.HakanSeven12.OpenCadStudio.svg

    install -D --mode=0444 assets/mimetypes/*.svg \
      $out/share/icons/hicolor/scalable/mimetypes

    install -D --mode=0444 packaging/OpenCADStudio.desktop \
      $out/share/applications/io.github.HakanSeven12.OpenCadStudio.desktop
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CAD application built with Rust — 2D/3D drawing, DWG/DXF support, and GPU-accelerated rendering";
    longDescription = ''
      Open CAD Studio is a cross-platform application for technical drawing, layout work, and solid modeling.
      It reads and writes DWG and DXF drawings natively, with a shared editing core across the desktop and
      browser versions.
    '';
    homepage = "https://opencadstudio.com";
    changelog = "https://github.com/HakanSeven12/OpenCADStudio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "OpenCADStudio";
  };
})
