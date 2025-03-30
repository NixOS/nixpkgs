{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  gradle,
  makeWrapper,
  jre,
  symlinkJoin,
}:
let
  pname = "alda";
  version = "2.3.1";
  src = fetchFromGitHub {
    owner = "alda-lang";
    repo = "alda";
    rev = "release-${version}";
    hash = "sha256-//VfegK8wkGKSpvtsNTEQqbVJkcucNiamoNIXaEBLb8=";
  };
  license = lib.licenses.epl20;

  alda_client = buildGoModule {
    pname = "${pname}-client";
    inherit version src;

    sourceRoot = "${src.name}/client";
    vendorHash = "sha256-h09w6ZLirLNxYv/ibeN5pCnXSvT+1FGiXiYNReZBMXI=";

    preBuild = ''
      go generate main.go
    '';

    env.CGO_ENABLED = 0;
    ldflags = [
      "-w"
      "-extldflags '-static'"
    ];
    tags = [ "netgo" ];
    subPackages = [ "." ];

    postInstall = ''
      mv $out/bin/client $out/bin/alda
    '';

    meta = {
      inherit license;
      homepage = "https://github.com/alda-lang/alda/tree/master/client";
      broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    };
  };
  alda_player = stdenv.mkDerivation {
    pname = "${pname}-player";
    inherit version src;

    sourceRoot = "${src.name}/player";
    nativeBuildInputs = [
      gradle
      makeWrapper
    ];

    mitmCache = gradle.fetchDeps {
      inherit pname;
      data = ./deps.json;
    };
    __darwinAllowLocalNetworking = true;

    gradleBuildTask = "fatJar";

    installPhase = ''
      mkdir -p $out/{bin,share}
      cp build/libs/alda-player-fat.jar $out/share

      makeWrapper ${lib.getExe jre} $out/bin/alda-player \
        --add-flags "-jar $out/share/alda-player-fat.jar"
    '';

    meta = {
      inherit license;
      homepage = "https://github.com/alda-lang/alda/tree/master/player";
    };
  };
in
symlinkJoin {
  inherit pname version;
  paths = [
    alda_client
    alda_player
  ];

  meta = {
    inherit license;
    description = "Music programming language for musicians";
    homepage = "https://alda.io";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = [ lib.maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
}
