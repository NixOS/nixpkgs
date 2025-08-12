{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comet-gog";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-asg2xp9A5abmsF+CgOa+ScK2sQwSNFQXD5Qnm76Iyhg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-K0lQuk2PBwnVlkRpYNo4Z7to/Lx2fY6RIlkgmMjvEtc=";

  nativeBuildInputs = [ protobuf ];

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    changelog = "https://github.com/imLinguin/comet/releases/tag/v${finalAttrs.version}";
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [
      tomasajt
      aidalgol
    ];
  };
})
