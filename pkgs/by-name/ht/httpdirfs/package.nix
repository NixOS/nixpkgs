{
  curl,
  expat,
  fetchFromGitHub,
  fuse3,
  gumbo,
  help2man,
  lib,
  libuuid,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httpdirfs";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-4Tp9DTYWUHElO0YNeINgzmbI0tpXxmKfZ1Jhz5UYn5M=";
  };

  nativeBuildInputs = [
    help2man
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    expat
    fuse3
    gumbo
    libuuid
  ];

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/fangfufu/httpdirfs/releases/tag/${finalAttrs.version}";
    description = "FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = with lib.maintainers; [ sbruder schnusch anthonyroussel ];
    platforms = lib.platforms.linux;
  };
})
