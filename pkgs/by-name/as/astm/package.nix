{
  stdenv,
  lib,
  nlohmann_json,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astm";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ritishDas";
    repo = "astm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZBg2MHAD5CVzaG4kwO447I78x/ZZKoJw/6ZFYp5EW9w=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];
  buildInputs = [ nlohmann_json ];

  buildPhase = ''
    runHook preBuild
    $CXX -std=c++17 -O2 astm.cpp -o astm
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 astm $out/bin/astm

    # recommended helper for completions
    installShellCompletion \
      --bash completions/astm.bash

    runHook postInstall
  '';

  meta = {
    description = "Asset Manager (astm) is a asset manager to store components in your device kinda like a mini personal shadcn/ui.";
    homepage = "https://github.com/ritishDas/astm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ritishDas ];
    platforms = lib.platforms.linux;
  };
})
