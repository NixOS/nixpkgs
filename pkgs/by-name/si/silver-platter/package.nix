{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  python3,
  makeBinaryWrapper,
  pkg-config,
  libiconv,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "silver-platter";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OFCD94yFshFcWBwh+M86a6vQ95D76VTdbVYrYD1uFgg=";
  };

  cargoHash = "sha256-AhAW4jgMcyRFQkpytvLl6e2U90liiQA1Cyg/kW3C6/w=";

  buildInputs = [
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeBuildInputs = [
    python3
    pkg-config

    python3.pkgs.wrapPython
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    python3.pkgs.breezy
  ];

  pythonPath = [
    python3.pkgs.breezy
  ];

  postFixup = ''
    wrapPythonPrograms
    for pgm in $out/bin/svp $out/bin/debian-svp; do
      wrapProgram "$pgm" \
        --set PYTHONNOUSERSITE "true" \
        --set PYTHONPATH "$program_PYTHONPATH"
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests = {
    python3-bindings = python3.pkgs.silver-platter;
  };

  meta = {
    description = "Automate the creation of merge proposals for scriptable changes";
    homepage = "https://jelmer.uk/code/silver-platter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "svp";
  };
})
