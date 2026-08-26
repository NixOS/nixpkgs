{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  gren,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gren-format";
  version = "1.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gilramir";
    repo = "gren-format";
    tag = finalAttrs.version;
    hash = "sha256-SQccMccXfWCcD3Y6S/7NHyRtxwBh438KketWYtqSvhM=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    gren
  ];

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 app $out/bin/gren-format

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/gren-format";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A code formatter for the Gren programming language";
    homepage = "https://github.com/gilramir/gren-format";
    license = lib.licenses.bsd3;
    mainProgram = "gren-format";
    maintainers = with lib.maintainers; [
      robinheghan
    ];
  };
})
