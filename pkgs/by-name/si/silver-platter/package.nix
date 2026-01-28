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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/GFTM/VF+b0I8cDY4vkHzSxCBbvpMiLBVVEPFHcn1/Q=";
  };

  cargoHash = "sha256-Y16OnSBC4v21NcCeWAwwGoFYJMQq/se25QqvpMyblmk=";

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
