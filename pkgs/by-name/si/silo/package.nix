{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:
let
  # The web client verifies that the server version is a valid datetime string:
  #
  # Example:
  #   versionToTimestamp "2026-04-17T00-00-00Z"
  #   => "2026-04-17T00:00:00Z"
  versionToTimestamp =
    version:
    let
      splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
    in
    builtins.concatStringsSep "" [
      (builtins.elemAt splitTS 0)
      (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1))
    ];

  # CopyrightYear will be printed to the CLI UI.
  # Example:
  #   versionToYear "2026-04-17T00-00-00Z"
  #   => "2026"
  versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
in
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "silo";
  version = "2026-08-06T00-00-00Z";

  src = fetchFromGitHub {
    owner = "pgsty";
    repo = "silo";
    tag = "RELEASE.${finalAttrs.version}";
    hash = "sha256-mFHgeetimgSgztA39oP4TcxdlFpI+Usjg7cvhyjsYRI=";
  };

  vendorHash = "sha256-7uXfM10x5ouCLNuk204AUi9up5oXVesPdNAbbGFyQ6U=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags =
    let
      t = "github.com/minio/minio/cmd";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${versionToTimestamp finalAttrs.version}"
      "-X ${t}.ReleaseTag=RELEASE.${finalAttrs.version}"
      "-X ${t}.CommitID=${finalAttrs.src.rev}"
      "-X ${t}.CopyrightYear=${versionToYear finalAttrs.version}"
    ];

  # Despite the renaming, the binary result comes out as minio. Upstream's goreleaser pipeline passes an explicit -o silo. The buildGoModule does not.
  postInstall = ''
    ln -s "$out/bin/minio" "$out/bin/silo"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "RELEASE.${finalAttrs.version}";
  };

  meta = {
    description = "Community-maintained fork of MinIO packaged as silo";
    homepage = "https://github.com/pgsty/silo";
    changelog = "https://github.com/pgsty/silo/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ randoneering ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "silo";
  };
})
