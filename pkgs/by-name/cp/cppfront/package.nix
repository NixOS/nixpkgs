{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppfront";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "hsutter";
    repo = "cppfront";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QYjon2EpNexYa2fl09AePkpq0LkRVBOQM++eldcVMvI=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  # Remove with next release
  postPatch = ''
    substituteInPlace source/version.info \
      --replace-fail "0.8.0" "0.8.1"
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    $CXX source/cppfront.cpp -std=c++20 -o cppfront

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin cppfront
    cp -r include $out/include

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests.hello-world = stdenv.mkDerivation (finalAttrs': {
      pname = "${finalAttrs.pname}-hello-world-test";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs'.src.name}/regression-tests";

      nativeBuildInputs = [
        finalAttrs.finalPackage
        installShellFiles
      ];

      postBuild = ''
        cppfront pure2-hello.cpp2
        $CXX -std=c++20 -o pure2-hello{,.cpp}
      '';

      postInstall = ''
        installBin pure2-hello
      '';

      doInstallCheck = true;
      postInstallCheck = ''
        $out/bin/pure2-hello | grep '^Hello \[world\]$' > /dev/null
      '';

      meta = {
        inherit (finalAttrs.meta) maintainers platforms;
        mainProgram = "pure2-hello";
      };
    });
  };

  meta = {
    description = "Experimental compiler from a potential C++ 'syntax 2' (Cpp2) to today's 'syntax 1' (Cpp1)";
    homepage = "https://hsutter.github.io/cppfront/";
    changelog = "https://github.com/hsutter/cppfront/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "cppfront";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [
      marcin-serwin
    ];
    platforms = lib.platforms.all;
  };
})
