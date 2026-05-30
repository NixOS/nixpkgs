{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  # The web client verifies, that the server version is a valid datetime string:
  # https://github.com/minio/minio/blob/3a0e7347cad25c60b2e51ff3194588b34d9e424c/browser/app/js/web.js#L51-L53
  #
  # Example:
  #   versionToTimestamp "2021-04-22T15-44-28Z"
  #   => "2021-04-22T15:44:28Z"
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
  #   versionToYear "2021-04-22T15-44-28Z"
  #   => "2021"
  versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
in
buildGoModule (finalAttrs: {
  pname = "minio";
  version = "2025-10-15T17-29-55Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${finalAttrs.version}";
    hash = "sha256-HbjmCJYkWyRRHKriLP6QohaXYLk3QEVfi32Krq3ujjo=";
  };

  vendorHash = "sha256-BFnTJE9QFWmPsx90hDTG8MusdnwaBPYJxM5bCFk3hew=";

  doCheck = false;

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
      "-X ${t}.CopyrightYear=${versionToYear finalAttrs.version}"
      "-X ${t}.ReleaseTag=RELEASE.${finalAttrs.version}"
      "-X ${t}.CommitID=${finalAttrs.src.rev}"
    ];

  passthru.tests.minio = nixosTests.minio;

  meta = {
    homepage = "https://www.minio.io/";
    description = "S3-compatible object storage server";
    changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      bachp
      ryan4yin
    ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "minio";
    knownVulnerabilities = [
      "CVE-2026-40344: MinIO has an Unauthenticated Object Write via Missing Signature Verification in Unsigned-Trailer Uploads"
      "CVE-2026-41145: Unauthenticated Object Write via Query-String Credential Signature Bypass in Unsigned-Trailer Uploads"
      "CVE-2026-33322: JWT Algorithm Confusion in OIDC Authentication"
      "CVE-2026-33419: LDAP login brute-force via user enumeration and missing rate limit"
      "CVE-2026-34204: SSE Metadata Injection via Replication Headers"
      "CVE-2026-39414: DoS via Unbounded Memory Allocation in S3 Select CSV Parsing"
      "minio has been abandoned by upstream and security issues won't be fixed. Users should migrate to alternatives such as Garage, SeaweedFS, or Ceph. S3-compatible clients such as rclone can be used to move data."
    ];
  };
})
