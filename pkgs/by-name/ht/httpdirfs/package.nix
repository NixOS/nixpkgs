{
  curl,
  expat,
  fetchFromGitHub,
  fuse,
  gumbo,
  help2man,
  lib,
  libuuid,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httpdirfs";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    rev = "refs/tags/${finalAttrs.version}";
    sha256 = "sha256-PUYsT0VDEzerPqwrLJrET4kSsWsQhtnfmLepeaqtA+I=";
  };

  postPatch = lib.optional stdenv.isDarwin ''
    substituteInPlace Makefile --replace-fail '-fanalyzer' '-Xanalyzer'
  '';

  nativeBuildInputs = [
    help2man
    pkg-config
  ];

  buildInputs = [
    curl
    expat
    fuse
    gumbo
    libuuid
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postBuild = ''
    make man
  '';

  passthru = {
    # Disabled for Darwin because requires macFUSE installed outside NixOS
    tests.version = lib.optionalAttrs stdenv.isLinux (
      testers.testVersion {
        command = "${lib.getExe finalAttrs.finalPackage} --version";
        package = finalAttrs.finalPackage;
      }
    );
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/fangfufu/httpdirfs/releases/tag/${finalAttrs.version}";
    description = "FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = with lib.maintainers; [ sbruder schnusch anthonyroussel ];
    platforms = lib.platforms.unix;
  };
})
