{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeWrapper,
  sqlite,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmd";
  version = finalAttrs.passthru.pin.version;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    tag = "v${finalAttrs.version}";
    hash = finalAttrs.passthru.pin.srcHash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ sqlite ];
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qmd
    mkdir -p $out/bin

    ln -s ${finalAttrs.passthru.node_modules}/node_modules $out/lib/qmd/node_modules
    cp -r src $out/lib/qmd/
    cp package.json $out/lib/qmd/

    makeWrapper ${bun}/bin/bun $out/bin/qmd \
      --add-flags "run --prefer-offline --no-install --cwd $out/lib/qmd $out/lib/qmd/src/cli/qmd.ts" \
      --set-default NODE_LLAMA_CPP_GPU false \
      --set DYLD_LIBRARY_PATH "${sqlite.out}/lib" \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath (
          [ sqlite ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            stdenv.cc.libc
            stdenv.cc.cc.lib
          ]
        )
      }"

    runHook postInstall
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    helpOutput="$($out/bin/qmd --help)"
    grep -q "qmd collection add" <<< "$helpOutput"

    runHook postInstallCheck
  '';

  passthru = {
    pin = lib.importJSON ./pin.json;
    node_modules = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;
      buildPhase = ''
        runHook preBuild

        bun install --no-progress --ignore-scripts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R node_modules $out/

        runHook postInstall
      '';

      dontPatchShebangs = true;
      dontFixup = true;
      outputHash = finalAttrs.passthru.pin.hashes.${stdenv.system};
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
  };

  meta = {
    description = "On-device search engine for markdown notes and knowledge bases";
    homepage = "https://github.com/tobi/qmd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "qmd";
    platforms = builtins.attrNames finalAttrs.passthru.pin.hashes;
  };
})
