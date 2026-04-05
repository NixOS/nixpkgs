{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildDubPackage rec {
  pname = "dscanner";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "D-Scanner";
    tag = "v${version}";
    hash = "sha256-7lZhYlK07VWpSRnzawJ2RL69/U/AH/qPyQY4VfbnVn4=";
  };

  preBuild = ''
    mkdir -p bin/
    echo "v${version}" > bin/dubhash.txt
  '';

  patches = [
    ./fix_version.patch
  ];

  dubLock = ./dub-lock.json;

  doCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/dscanner -t $out/bin
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Swiss-army knife for D source code";
    changelog = "https://github.com/dlang-community/D-Scanner/releases/tag/v${version}";
    homepage = "https://github.com/dlang-community/D-Scanner";
    mainProgram = "dscanner";
    maintainers = with lib.maintainers; [ ipsavitsky ];
    license = lib.licenses.boost;
  };
}
