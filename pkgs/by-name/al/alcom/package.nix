{
  buildDotnetModule,
  cargo-about,
  cargo-tauri,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  google-fonts,
  lib,
  libsoup,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk,
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
    nugetDeps = ./deps.nix;
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    dotnetSdk
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking
      libsoup
      webkitgtk
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

  meta = with lib; {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    mainProgram = "alcom";
  };
}
