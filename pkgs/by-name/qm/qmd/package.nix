{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
  sqlite,
  runCommand,
}:
let
  pin = lib.importJSON ./pin.json;
  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    rev = pin.rev;
    hash = pin.srcHash;
  };
  node_modules = stdenv.mkDerivation {
    pname = "qmd-node_modules";
    inherit src;
    version = pin.version;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    buildPhase = ''
      export HOME=$(mktemp -d)
      bun install --no-progress --frozen-lockfile
    '';
    installPhase = ''
      mkdir -p $out/node_modules
      cp -R ./node_modules $out
    '';
    dontPatchShebangs = true;
    dontFixup = true;
    outputHash = pin."${stdenv.system}";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qmd";
  version = pin.version;
  inherit src;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ sqlite ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qmd
    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out/lib/qmd/node_modules
    cp -r src $out/lib/qmd/
    cp package.json $out/lib/qmd/

    makeBinaryWrapper ${bun}/bin/bun $out/bin/qmd \
      --add-flags "run --prefer-offline --no-install --cwd $out/lib/qmd $out/lib/qmd/src/qmd.ts" \
      --set DYLD_LIBRARY_PATH "${sqlite.out}/lib" \
      --set LD_LIBRARY_PATH "${sqlite.out}/lib"

    runHook postInstall
  '';

  passthru.tests.version = runCommand "qmd-test" { } ''
    ${lib.getExe finalAttrs.finalPackage} --help > $out
    grep -q "qmd collection add" $out
  '';

  meta = {
    description = "On-device search engine for markdown notes and knowledge bases";
    homepage = "https://github.com/tobi/qmd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tlehman ];
    mainProgram = "qmd";
    platforms = lib.platforms.unix;
  };
})
