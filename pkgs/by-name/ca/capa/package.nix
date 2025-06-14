{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  buildGoModule, # for testing capa executable against binary
  writableTmpDirAsHomeHook,
  runCommand,
  capa,
  libz,
}:

let
  version = "9.2.1";
  srcs =
    let
      linuxHash = "sha256-pnWf1KXSSj7oCK0JL7v21/6D+9Mt8C/EPnH5mO7PKTg=";
      darwinHash = "sha256-/sKCEF6AJinV3jAp77ZlCLT2hDCPktoCEanauXpxag8=";
    in
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-linux.zip";
        hash = linuxHash;
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-macos.zip";
        hash = darwinHash;
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-macos.zip";
        hash = darwinHash;
      };
    };
in
stdenv.mkDerivation (finalAttrs: {
  name = "capa";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs =
    [
      unzip
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      libz
    ];

  dontUnpack = true;
  dontFixup = stdenv.hostPlatform.isDarwin; # Fixing up causes this error: `Could not load PyInstaller's embedded PKG archive from the executable`

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    unzip $src -d $out/bin
    runHook postInstall
  '';

  passthru.updateScript = ./update-hashes.sh;
  passthru.tests = {
    simple =
      let
        # Build tiny binary for testing
        testBin = buildGoModule {
          name = "hello-world";
          vendorHash = null;
          src = ./tests;
          nativeBuildInputs = [ writableTmpDirAsHomeHook ];
          buildPhase = ''
            mkdir -p $out/bin
            GOOS=windows GOARCH=amd64 go build -o $out/bin/hello-world.exe $src/hello-world.go
          '';
        };
      in
      runCommand "${finalAttrs.name}-go-test" { } ''
        mkdir -p $out
        HOME=/tmp/capa-test ${capa}/bin/capa --rules ${./tests/rules} ${testBin}/bin/hello-world.exe > $out/result.txt
        grep -q "compiled with Go" $out/result.txt
      '';
  };

  meta = {
    changelog = "https://github.com/mandiant/capa/releases/tag/${version}";
    description = "Open-source tool to identify capabilities in executable files";
    homepage = "https://mandiant.github.io/capa/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heywoodlh ];
    mainProgram = "capa";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin" # Executable is x86_64 binary, but Rosetta on Apple Silicon Macs should handle this
    ];
  };
})
