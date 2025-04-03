{
  buildDotnetModule,
  cargo-about,
  cargo-tauri,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  wrapGAppsHook4,
  webkitgtk_4_1,
}:
let
  pname = "alcom";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    tag = "gui-v${version}";
    fetchSubmodules = true;
    hash = "sha256-cOx7X3xfTBYpXhv1zIRStaIpyGWSp+d7qzdJLGzXtDY=";
  };

  subdir = "vrc-get-gui";

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

  patches = [
    ./disable-updater-artifacts.patch
  ];

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    dotnetSdk
    nodejs
    npmHooks.npmConfigHook
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libsoup_3
      makeBinaryWrapper
      webkitgtk_4_1
    ]
    ++ dotnetSdk.packages
    ++ dotnetBuild.nugetDeps;

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ph6QZW21JYQJgrUecN+MklWuY51iKC2glPEdgxw+3r8=";
  buildAndTestSubdir = subdir;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/${subdir}";
    hash = "sha256-lWQPBILZn8VGoILfEY2bMxGaBL2ALGbvcT5RqanTNyY=";
  };
  npmRoot = subdir;

  preConfigure = ''
    dotnet restore "vrc-get-litedb/dotnet/vrc-get-litedb.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/ALCOM \
      --set APPIMAGE ALCOM
  '';

  passthru = {
    inherit (dotnetBuild) fetch-deps;
  };

  meta = {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "alcom";
  };
}
