{ stdenv
, lib
, fetchFromGitHub
, stdenvNoCC
, jq
, moreutils
, nodePackages
, cacert
, rustPlatform
, cargo
, rustc
, cargo-tauri
, pkg-config
, openssl
, libsoup
, wrapGAppsHook
, gtk3
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "en-croissant";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5Qt/OvsMw5G6Q9WN+OTdWVlJQlEz/F6C6z3zO05uOlM=";
  };

  sourceRoot = "${src.name}/src-tauri";

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    pnpmPatch = builtins.toJSON {
      pnpm.supportedArchitectures = {
        os = [ "linux" ];
        cpu = [ "x64" "arm64" ];
      };
    };

    postPatch = ''
      mv package.json package.json.orig
      jq --raw-output ". * $pnpmPatch" package.json.orig > package.json
    '';

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      # use --frozen-lockfile to avoid checking git deps
      pnpm install --frozen-lockfile

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = {
      x86_64-linux = "sha256-Q1VyEUFeUrcyGkMDl360839QHfzSbbWthqj6akYaP+k=";
    }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "vampirc-uci-0.11.1" = "sha256-I6Wgshyztuh5nEfTjd4ISqef8nXj1SOxi+fwbhO+1ic=";
      "tauri-plugin-log-0.0.0" = "sha256-vNX3Sv3AcmaoejC7ulkznXmWLmjKVtL2z40cQ6fPjWM=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    wrapGAppsHook
    nodePackages.pnpm
    pkg-config
  ];

  buildInputs = [
    gtk3
    openssl
    libsoup
    webkitgtk
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpm-deps}
    chmod +w ..
    pnpm install --frozen-lockfile
    cargo tauri build -b deb
  '';

  preInstall = ''
    mv target/release/bundle/deb/*/data/usr/ $out
  '';

  meta = with lib; {
    description = "A Modern Chess Database";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    maintainers = [ maintainers.lcscosta ];
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    mainProgram = "en-croissant";
  };
}
