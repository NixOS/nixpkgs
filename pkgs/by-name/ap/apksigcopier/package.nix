{
  lib,
  apksigner,
  bash,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apksigcopier";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigcopier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VuwSaoTv5qq1jKwgBTKd1y9RKUzz89n86Z4UBv7Q51o=";
  };

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ apksigner ]}"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /bin/bash ${bash}/bin/bash
  '';

  postBuild = ''
    make apksigcopier.1
  '';

  postInstall = ''
    installManPage apksigcopier.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/apksigcopier --version | grep "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Copy/extract/patch android apk signatures & compare APKs";
    mainProgram = "apksigcopier";
    longDescription = ''
      apksigcopier is a tool for copying android APK signatures from a signed
      APK to an unsigned one (in order to verify reproducible builds).
      It can also be used to compare two APKs with different signatures.
      Its command-line tool offers four operations:

      * copy signatures directly from a signed to an unsigned APK
      * extract signatures from a signed APK to a directory
      * patch previously extracted signatures onto an unsigned APK
      * compare two APKs with different signatures (requires apksigner)
    '';
    homepage = "https://github.com/obfusk/apksigcopier";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ obfusk ];
  };
})
