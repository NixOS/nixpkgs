{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  gitUpdater,
}:

buildGoModule (finalAttrs: {
  pname = "corerad";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tVK4chDV26vpuTaqVWe498j8ijZN2OOhe97LLE+xK9Y=";
  };

  vendorHash = "sha256-cmfRN7mU99TBtYmCsuHzliYqdfUHzDOFvKbnTZJqhLg=";

  # Since the tarball pulled from GitHub doesn't contain git tag information,
  # we fetch the expected tag's timestamp from a file in the root of the
  # repository.
  preBuild = ''
    ldflags+=" -X github.com/mdlayher/corerad/internal/build.linkVersion=v${finalAttrs.version}"
    ldflags+=" -X github.com/mdlayher/corerad/internal/build.linkTimestamp=$(<.gittagtime)"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      inherit (nixosTests) corerad;
    };
  };

  meta = {
    homepage = "https://github.com/mdlayher/corerad";
    description = "Extensible and observable IPv6 NDP RA daemon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mdlayher
      jmbaur
    ];
    platforms = lib.platforms.linux;
    mainProgram = "corerad";
  };
})
