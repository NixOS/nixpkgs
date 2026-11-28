{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  sqlite,
  aws-lc,
  versionCheckHook,

  meson,
  ninja,
  pkgsCross,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comet-gog";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NK3td9huujLM2sSU/gMPV0Bak+i+6BDwre/z/JNlR1M=";
    fetchSubmodules = true;
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Resolve protoc from PATH
  # TECHNICALLY, we could remove this, but then we'd be using the vendored precompiled protoc binary...
  env.PROTOC = "protoc";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    aws-lc
    sqlite
  ];

  cargoHash = "sha256-iOG52ZT1oRjqUVd81UhRdXUgDkIky0qrboZfVJjuoSk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.dummy-service = stdenv.mkDerivation {
    pname = "galaxy-dummy-service";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/dummy-service";

    nativeBuildInputs = [
      meson
      ninja
      pkgsCross.mingw-msvcrt-x86_64.buildPackages.gcc
    ];

    mesonFlags = [
      "--cross-file meson/x86_64-w64-mingw32.ini"
    ];

    installPhase = ''
      runHook preInstall
      install -D GalaxyCommunication.exe -t "$out"/
      runHook postInstall
    '';
  };

  meta = {
    changelog = "https://github.com/imLinguin/comet/releases/tag/${finalAttrs.src.tag}";
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [
      tomasajt
    ];
  };
})
