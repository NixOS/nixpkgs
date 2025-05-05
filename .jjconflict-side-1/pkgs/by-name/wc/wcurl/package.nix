{
  stdenvNoCC,
  lib,
  coreutils,
  curl,
  fetchFromGitHub,
  gnused,
  installShellFiles,
  nix-update-script,
  makeBinaryWrapper,
  shunit2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wcurl";
  version = "2025.04.20";

  src = fetchFromGitHub {
    owner = "curl";
    repo = "wcurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ZW1VTtggp72vDgOAnieWK68ITU+E5x0gV2N2IJ5JDQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [ shunit2 ];

  doCheck = true;

  dontBuild = true;

  postPatch = ''
    substituteInPlace wcurl \
      --replace-fail '"curl "' '"${curl}/bin/curl "'
  '';

  checkPhase = ''
    runHook preCheck

    tests/tests.sh

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D wcurl -t $out/bin
    installManPage wcurl.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/wcurl \
      --inherit-argv0 \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://curl.se/wcurl";
    description = "Simple wrapper around curl to easily download files";
    mainProgram = "wcurl";
    license = lib.licenses.curl;
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.all;
  };
})
