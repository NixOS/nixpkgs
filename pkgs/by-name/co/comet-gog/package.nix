{
  comet-gog_kind ? "latest",

  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,

  meson,
  ninja,
  pkgsCross,
}:

let
  versionInfoTable = {
    "latest" = {
      version = "0.3.1";
      srcHash = "sha256-asg2xp9A5abmsF+CgOa+ScK2sQwSNFQXD5Qnm76Iyhg=";
      cargoHash = "sha256-K0lQuk2PBwnVlkRpYNo4Z7to/Lx2fY6RIlkgmMjvEtc=";
    };
    # version pin that is compatible with heroic
    "heroic" = {
      version = "0.2.0";
      srcHash = "sha256-LAEt2i/SRABrz+y2CTMudrugifLgHNxkMSdC8PXYF0E=";
      cargoHash = "sha256-SvDE+QqaSK0+4XgB3bdmqOtwxBDTlf7yckTR8XjmMXc=";
    };
  };

  versionInfo = versionInfoTable.${comet-gog_kind};
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comet-gog";
  inherit (versionInfo) version cargoHash;

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${finalAttrs.version}";
    hash = versionInfo.srcHash;
    fetchSubmodules = true;
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  # TECHNICALLY, we could remove this, but then we'd be using the vendored precompiled protoc binary...
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  passthru.dummy-service = stdenv.mkDerivation {
    pname = "galaxy-dummy-service";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/dummy-service";

    nativeBuildInputs = [
      meson
      ninja
      pkgsCross.mingwW64.buildPackages.gcc
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
