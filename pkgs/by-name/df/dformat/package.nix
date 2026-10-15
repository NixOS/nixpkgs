{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildDubPackage rec {
  pname = "dfmt";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dfmt";
    tag = "v${version}";
    hash = "sha256-QjmYPIQFs+91jB1sdaFoenfWt5TLXyEJauSSHP2fd+M=";
  };

  preBuild = ''
    mkdir -p bin/
    echo "v${version}" > bin/dubhash.txt
  '';

  patches = [
    # do not run the dubhash tool, we supply the version in preBuild
    ./fix_version.patch
  ];

  dubLock = ./dub-lock.json;

  doCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/dfmt -t $out/bin
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Formatter for D source code";
    changelog = "https://github.com/dlang-community/dfmt/releases/tag/v${version}";
    homepage = "https://github.com/dlang-community/dfmt";
    maintainers = with lib.maintainers; [ ipsavitsky ];
    mainProgram = "dfmt";
    license = lib.licenses.boost;
  };
}
