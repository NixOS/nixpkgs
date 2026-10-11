{
  autoPatchelfHook,
  fetchFromGitHub,
  fetchurl,
  lib,
  runCommand,
  stdenvNoCC,
  writeShellScript,
  pkgsBuildHost,
}:
let
  fetch =
    {
      url,
      hash,
      name,
    }:
    let
      src = fetchurl { inherit url hash; };
    in
    runCommand name { } ''
      mkdir -p $out
      tar -xf ${src} -C $out
    '';

  platforms = {
    "x86_64-linux" = "default-linux-x86_64";
    "aarch64-linux" = "default-linux-aarch64";
  };

  manifest = (lib.importJSON ./manifest.json);

  tools = lib.mapAttrs (name: v: {
    sbr = v.sbr;
    pkg = fetch {
      inherit (v) url hash;
      inherit name;
    };
  }) manifest.tools.${stdenvNoCC.buildPlatform.system};

  targets = [ "perforator/cmd/cli" ];
in
stdenvNoCC.mkDerivation rec {
  pname = "perforator";
  version = manifest.version;

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "perforator";
    rev = "v${version}";
    hash = manifest.hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  configurePhase =
    ''
      export YA_CACHE_DIR=.ya
      mkdir -p $YA_CACHE_DIR/tools/v3
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (name: tool: ''
        mkdir -p $YA_CACHE_DIR/tools/v3/${tool.sbr}
        cp -sr ${tool.pkg}/* $YA_CACHE_DIR/tools/v3/${tool.sbr}
        echo -n "2" > $YA_CACHE_DIR/tools/v3/${tool.sbr}/INSTALLED
      '') tools
    );

  buildPhase = ''
    ${
      pkgsBuildHost.buildFHSEnv {
        name = "fhs";
        targetPkgs = pkgs: with pkgs; [ libxcrypt-legacy ];
      }
    }/bin/fhs ${writeShellScript "build" ''
      ${tools.YA.pkg}/ya-bin make -T --noya-tc --target-platform ${
        platforms.${stdenvNoCC.hostPlatform.system}
      } -j $NIX_BUILD_CORES -o ./result ${lib.concatStringsSep " " targets}
    ''}
  '';

  installPhase =
    ''
      mkdir -p $out/bin
    ''
    + lib.concatStrings (
      map (target: ''
        cp ./result/${target}/* $out/bin/
      '') targets
    );

  passthru.updateScript =
    [
      ./update.py
      "--repository"
      "https://github.com/yandex/perforator"
      "--output"
      "pkgs/by-name/pe/perforator/manifest.json"
      "--targets"
    ]
    ++ targets
    ++ [ "--platforms" ]
    ++ lib.mapAttrsToList (k: v: k) platforms;

  meta = {
    homepage = "https://github.com/yandex/perforator";
    description = "Cluster-wide continuous profiling tool designed for large data centers";
    license = with lib.licenses; [
      mit
      gpl2
    ];
    mainProgram = "perforator";
    platforms = [ "x86_64-linux" ];
  };
}
