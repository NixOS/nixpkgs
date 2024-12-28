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
  webkitgtk_4_1,
  writeShellScriptBin,
}:
let
  pname = "alcom";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    tag = "gui-v${version}";
    fetchSubmodules = true;
    hash = "sha256-ph9dJhm4DbI6/we/HD4T1LOafaWylhHoNT+zaYgl4f8=";
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

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    dotnetSdk
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    (writeShellScriptBin "git" "echo 'nixpkgs-${src.tag}'")
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
  cargoHash = "sha256-C03XPIPzPfVG3K/KoPKU+9475OljtYgkwjE+dxVKYls=";
  buildAndTestSubdir = subdir;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/${subdir}";
    hash = "sha256-QAUoz/mzF9aDvkILKX3rxkYUC+VmJeRVjG8vJ/b0Dho=";
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
