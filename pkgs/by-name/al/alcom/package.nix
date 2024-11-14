{
  buildDotnetModule,
  cargo-about,
  cargo-tauri_1,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  google-fonts,
  lib,
  libsoup_2_4,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk_4_0,
}:
let
  pname = "alcom";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-jkhjJTb/U2dXj/vyaip+gWoqIOdfFKSExeDl0T11DE4=";
  };

  subdir = "vrc-get-gui";

  google-fonts' = google-fonts.override {
    fonts = [
      "NotoSans"
      "NotoSansJP"
    ];
  };

  dotnetSdk = dotnetCorePackages.sdk_8_0;
  dotnetRuntime = dotnetCorePackages.runtime_8_0;

  dotnetBuild = buildDotnetModule {
    inherit pname version src;

    dotnet-sdk = dotnetSdk;
    dotnet-runtime = dotnetRuntime;

    projectFile = [
      "vrc-get-litedb/dotnet/vrc-get-litedb.csproj"
      "vrc-get-litedb/dotnet/LiteDB/LiteDB/LiteDB.csproj"
    ];
    nugetDeps = ./deps.json;
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  nativeBuildInputs = [
    cargo-about
    cargo-tauri_1.hook
    dotnetSdk
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libsoup_2_4
      webkitgtk_4_0
    ]
    ++ dotnetSdk.packages
    ++ dotnetBuild.nugetDeps;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-single-instance-0.0.0" = "sha256-Mf2/cnKotd751ZcSHfiSLNe2nxBfo4dMBdoCwQhe7yI=";
    };
  };
  buildAndTestSubdir = subdir;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/${subdir}";
    hash = "sha256-4zokKLhLgW2u1GxeTlIAAxJINSpxHRtY5HXmhi9nj6c=";
  };
  npmRoot = subdir;

  patches = [
    ./use-local-fonts.patch
  ];

  postPatch = ''
    install -Dm644 "${google-fonts'}/share/fonts/truetype/NotoSans[wdth,wght].ttf" ${subdir}/app/fonts/noto-sans.ttf
    install -Dm644 "${google-fonts'}/share/fonts/truetype/NotoSansJP[wght].ttf" ${subdir}/app/fonts/noto-sans-jp.ttf
  '';

  preConfigure = ''
    dotnet restore "vrc-get-litedb/dotnet/vrc-get-litedb.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true
  '';

  passthru = {
    inherit (dotnetBuild) fetch-deps;
  };

  meta = {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    # aarch64-linux: Error failed to build app: Target aarch64-unknown-linux-gnu does not exist. Please run `rustup target list` to see the available targets.
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
    mainProgram = "alcom";
  };
}
