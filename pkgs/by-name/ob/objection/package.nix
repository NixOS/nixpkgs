{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchurl,
  frida-tools,
  apktool,
  aapt,
  apksigner,
  android-tools,
  androidenv,
  makeWrapper,
  buildNpmPackage,
  stdenv,
}:
let
  androidComposition = androidenv.composeAndroidPackages { };
  version = "1.12.5";
  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "objection";
    tag = version;
    hash = "sha256-o8NrzSGwFObv1J57BX40xCOB7Q/royU/OpK31KhPEIo=";
  };

  fridaVersion = "17.14.0";

  supportedPlatforms = {
    x86_64-linux = {
      fridaArch = "linux-x64";
      fridaHash = "sha256-i9IvLg27+HtGuFIA2gcmbrDCVECflpaVU7GbfOx3/LI=";
    };
    aarch64-darwin = {
      fridaArch = "darwin-arm64";
      fridaHash = "sha256-cJw1Gksb0W2bMLTeLPyN6nPyQD4QnrA49Dao9Y8C5Ro=";
    };
  };

  currentPlatform =
    supportedPlatforms.${stdenv.hostPlatform.system}
      or (throw "frida Node.js binding: unsupported system ${stdenv.hostPlatform.system}");

  fridaNodeBinding = fetchurl {
    url = "https://github.com/frida/frida/releases/download/${fridaVersion}/frida-v${fridaVersion}-napi-v8-${currentPlatform.fridaArch}.tar.gz";
    hash = currentPlatform.fridaHash;
  };

  runtimeTools = [
    apktool
    aapt
    apksigner
    android-tools
  ];

  agent = buildNpmPackage {
    pname = "objection-agent";
    inherit version src;
    sourceRoot = "source/agent";

    npmDepsHash = "sha256-OPN1sUgDsM+p+mcI1wW0hmIKO/eIzDe0TyMCsf6lpxk=";

    npmRebuildFlags = [ "--ignore-scripts" ];

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail '"frida-compile src/index.ts -o ../objection/agent.js -T none"' \
                       '"frida-compile src/index.ts -o ./agent.js -T none"'
    '';

    preBuild = ''
      mkdir -p node_modules/frida
      tar -xzf ${fridaNodeBinding} -C node_modules/frida
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 agent.js $out/agent.js
      runHook postInstall
    '';
  };
in
python3Packages.buildPythonApplication {
  pname = "objection";
  inherit version src;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dependencies = with python3Packages; [
    frida-python
    frida-tools
    prompt-toolkit
    click
    tabulate
    semver
    delegator-py
    requests
    flask
    pygments
    setuptools
    packaging
    litecli
  ];

  pythonImportsCheck = [
    "objection"
  ];

  doCheck = true;

  pythonRuntimeDepsCheck = true;

  postUnpack = ''
    cp ${agent}/agent.js $sourceRoot/objection/
  '';

  postFixup = ''
    mkdir -p "$out/bin-wrapped"
    ln -s "${aapt}/bin/aapt2" "$out/bin-wrapped/aapt"
    BUILD_TOOLS_PATH="${androidComposition.androidsdk}/libexec/android-sdk/build-tools"
    if [ -d "$BUILD_TOOLS_PATH" ]; then
      LATEST_BUILD_TOOLS=$(ls -d "$BUILD_TOOLS_PATH"/* 2>/dev/null | sort -V | tail -1)
      [ -n "$LATEST_BUILD_TOOLS" ] && ln -s "$LATEST_BUILD_TOOLS/zipalign" "$out/bin-wrapped/zipalign" 2>/dev/null || true
    fi

    wrapProgram $out/bin/objection \
      --prefix PATH : "$out/bin-wrapped:${lib.makeBinPath runtimeTools}"
  '';

  meta = {
    description = "Runtime mobile exploration toolkit, powered by Frida";
    longDescription = ''
      objection is a runtime mobile exploration toolkit, powered by Frida,
      built to help you assess the security posture of your mobile applications,
      without needing a jailbreak.
    '';
    homepage = "https://github.com/sensepost/objection";
    changelog = "https://github.com/sensepost/objection/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nullstring1 ];
    mainProgram = "objection";
    platforms = builtins.attrNames supportedPlatforms;
  };
}
