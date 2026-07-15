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
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "silver-platter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KafDAd457Kp2SK9ZCmslaTMd6Wx45fszQ0tzuqInT+o=";
  };

  cargoHash = "sha256-j+zKH4ZLYdaJnHp2vU1yZXEx0k17dwb7iZmC2najFPk=";

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
