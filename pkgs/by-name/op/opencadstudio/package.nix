{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencadstudio";
  version = "2026.41";
  src = fetchFromGitHub {
    owner = "HakanSeven12";
    repo = "OpenCADStudio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fiyvfldfEMNTWBJMtiTBP4ISFaYFEdB6ymzmf3bgO4=";
  };

  cargoHash = "sha256-Z+aLHJk1mR77ZJ9a29CWOhPr4+SBQ2cPHWk8hjUPh5Y=";

  __structuredAttrs = true;
  # to test local http api (app::control::http_bridge::*)
  __darwinAllowLocalNetworking = true;

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

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/{apps,mimetypes}

    install -D --mode=0444 assets/logo.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.HakanSeven12.OpenCadStudio.svg

    install -D --mode=0444 assets/mimetypes/*.svg \
      $out/share/icons/hicolor/scalable/mimetypes

    install -D --mode=0444 packaging/OpenCADStudio.desktop \
      $out/share/applications/io.github.HakanSeven12.OpenCadStudio.desktop

    substituteInPlace $out/share/applications/io.github.HakanSeven12.OpenCadStudio.desktop \
      --replace-fail "Exec=OpenCADStudio %F" "Exec=$out/bin/OpenCADStudio %F"
  '';

  passthru = {
    updateScript = nix-update-script { };
    web = callPackage ./web.nix {
      inherit (finalAttrs) version src cargoHash;
    };
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
