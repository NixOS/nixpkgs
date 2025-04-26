{
  lib,
  fetchFromGitHub,
  buildDubPackage,
}:

buildDubPackage rec {
  pname = "dcd";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "DCD";
    tag = "v${version}";
    hash = "sha256-dJ4Ql3P9kPQhQ3ZrNcTAEB5JHSslYn2BN8uqq6vGetY=";
  };

  dubLock = ./dub-lock.json;

  buildPhase = ''
    runHook preBuild

    dub build --build=release --config=server
    dub build --build=release --config=client

    runHook postBuild
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/dcd-{client,server} -t "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Auto-complete program for the D programming language";
    homepage = "https://github.com/dlang-community/DCD";
    changelog = "https://github.com/dlang-community/DCD/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
