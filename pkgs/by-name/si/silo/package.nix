{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
  version = "2026-06-18T00-00-00Z";

  src = fetchFromGitHub {
    owner = "pgsty";
    repo = "minio";
    tag = "RELEASE.${finalAttrs.version}";
    hash = "sha256-TwuqWof8FozryQoZt1lybw7z8z8E3Ose4jbKZ0To2lk=";
  };

  vendorHash = "sha256-rewz3Sez/01iWGCEhMVmcVnIxxjgBzmeUyMqFi6s4mc=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  # nixpkgs go_1_26 pinned to 1.26.3; pgsty/minio's go.mod says go 1.26.4.
  # Step down to 1.26.3 to use the available toolchain. If pgsty/minio
  # genuinely needs 1.26.4 features, we can replace this with one of:
  #   - Go toolchain auto-switch: prePatch GOTOOLCHAIN=go1.26.4+auto
  #     (fails inside Nix sandbox since GOPROXY=off blocks toolchain download)
  #   - Override go: buildGoModule.override { go = go_1_26.overrideAttrs ... }
  #     (compile go 1.26.4 from source, ~5–10 min)
  #   - Wait for nixpkgs to bump go_1_26 past 1.26.4
  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.26.4" "go 1.26.3"
  '';

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

  postInstall = ''
    ln -s "$out/bin/minio" "$out/bin/silo"
  '';

  meta = {
    description = "Community-maintained fork of MinIO packaged as silo";
    homepage = "https://github.com/pgsty/minio";
    changelog = "https://github.com/pgsty/minio/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ randoneering ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "silo";
  };
})
