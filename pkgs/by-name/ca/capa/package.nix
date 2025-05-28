{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  buildGoModule, # for testing capa executable against binary
  runCommand,
  capa
}:

let
  version = "9.2.0";
  srcs = let
    linuxHash = "1r80h82jnhjqmwyb1wpcnb4jfxkxbigahbfl1p7vr39igigqii22";
    darwinHash = "0hmivhk3ism7pdinf1453cz53bw0mq1zh9ahjcqv2v3pfb6kvvlh";
  in {
    x86_64-linux = fetchurl {
      url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-linux.zip";
      sha256 = "${linuxHash}";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-macos.zip";
      sha256 = "${darwinHash}";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/mandiant/capa/releases/download/v${version}/capa-v${version}-macos.zip";
      sha256 = "${darwinHash}";
    };
  };
in stdenv.mkDerivation (finalAttrs: {
  name = "capa";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [
    unzip
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  dontUnpack = true;
  dontFixup = stdenv.hostPlatform.isDarwin; # Fixing up causes this error: `Could not load PyInstaller's embedded PKG archive from the executable`

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    unzip $src -d $out/bin
    runHook postInstall
  '';

  passthru.tests = {
    simple = let
      # Build tiny binary for testing
      testBin = buildGoModule {
        name = "hello-world";
        vendorHash = lib.fakeHash;
        src = ./tests/hello-world.go;
        phases = [ "buildPhase" ];
        buildPhase = ''
          mkdir -p $out/bin
          GOOS=windows GOARCH=amd64 go build -o $out/bin/hello-world.exe $src
        '';
      };
    in runCommand "${finalAttrs.name}-go-test" { } ''
      ${capa}/bin/capa --rules ${./tests/rules} ${testBin}/bin/hello-world.exe | grep -q 'compiled with Go'
    '';
  };

  meta = with lib; {
    changelog = "https://github.com/mandiant/capa/releases/tag/${version}";
    description = "Open-source tool to identify capabilities in executable files";
    homepage = "https://mandiant.github.io/capa/";
    license = "apache-2.0";
    maintainers = with maintainers; [ heywoodlh ];
    mainProgram = "capa";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin" # Executable is x86_64 binary, but Rosetta on Apple Silicon Macs should handle this
    ];
  };
})
