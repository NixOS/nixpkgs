{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  python3,
  runCommand,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lark-cli";
  version = "1.0.88";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MRaFOq+0+ieNPG23ncYot/kp5hyWER7bX95I+trLHbw=";
  };

  vendorHash = "sha256-WClES7ilNmQ0018Qf13tNHouE/SIwh99MaewZ7VGQ2E=";

  subPackages = [ "." ];

  # The registry of Open Platform APIs that lark-cli embeds at build time
  # (internal/registry/meta_data.json). Upstream regenerates this file on
  # every build from a live endpoint (scripts/fetch_meta.py,
  # https://open.feishu.cn/api/tools/open/api_definition?protocol=meta).
  # That endpoint serves a continuously updated document with no way to pin
  # a version: the "data_version" parameter is only an exact-match
  # conditional against a constant "1.0.0" that is never bumped,
  # "client_version" is ignored, and there is no ETag, Last-Modified or
  # historical access. Hash-pinning such a URL breaks as soon as the content
  # drifts, and old revisions of this package become unbuildable because the
  # bytes behind the URL are gone forever; this already happened to 1.0.58.
  #
  # The official release binaries embed the exact registry that upstream
  # built the corresponding version with (build.sh runs fetch_meta.py before
  # go build, and loader_embedded.go go:embeds the file). Release artifacts
  # are immutable per version and checksummed upstream, so we extract the
  # registry from the binary for this exact version instead: byte-exact,
  # version-faithful (building 1.0.x yields the registry the official 1.0.x
  # binary ships with) and reproducible for old revisions. Extraction is a
  # pure byte scan, so the linux-amd64 tarball works on every platform.
  # Hash recorded in the release checksums.txt.
  metaDataRelease = fetchurl {
    name = "lark-cli-${finalAttrs.version}-linux-amd64.tar.gz";
    url = "https://github.com/larksuite/cli/releases/download/v${finalAttrs.version}/lark-cli-${finalAttrs.version}-linux-amd64.tar.gz";
    hash = "sha256-SX3iCTms3SquTImP6noMpx1aRZ7VQyAudiqLyzIo7/4=";
  };

  metaData =
    runCommand "meta_data.json-${finalAttrs.version}"
      {
        nativeBuildInputs = [ python3 ];
      }
      ''
        tar xf ${finalAttrs.metaDataRelease} lark-cli
        python3 ${./extract-meta.py} lark-cli $out
      '';

  postPatch = ''
    cp ${finalAttrs.metaData} internal/registry/meta_data.json
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/lark-cli
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/larksuite/cli/internal/build.Version=v${finalAttrs.version}"
    "-X github.com/larksuite/cli/internal/build.Date=2026-06-01"
  ];

  passthru = {
    inherit (finalAttrs) metaData;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "metaDataRelease"
      ];
    };
  };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "lark-cli --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "The official CLI for Lark/Feishu open platform";
    homepage = "https://github.com/larksuite/cli";
    changelog = "https://github.com/larksuite/cli/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zehuajun ];
    mainProgram = "lark-cli";
  };
})
