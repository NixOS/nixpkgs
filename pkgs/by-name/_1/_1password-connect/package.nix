{
  lib,
  stdenvNoCC,
  dockerTools,
  autoPatchelfHook,
  jq,
  libarchive,
  testers,
}:
let
  hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
  version = hashes.version;
  arch =
    if stdenvNoCC.hostPlatform.isx86_64 then
      "amd64"
    else if stdenvNoCC.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "Unsupported architecture";

  # upstream is only distributed via docker images
  # both images are updated in parallel
  pullConnectImage =
    image:
    dockerTools.pullImage {
      imageName = "1password/${image}";
      finalImageTag = version;
      inherit arch;
      imageDigest = hashes.${image}.digest;
      hash = hashes.${image}.hashes.${arch};
    };

  apiImage = pullConnectImage "connect-api";
  syncImage = pullConnectImage "connect-sync";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "1password-connect";
  inherit version;
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    jq
    libarchive
  ];

  apiImageSrc = apiImage;
  syncImageSrc = syncImage;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    extract_binary() {
      local image_tar="$1"
      local binary="$2"
      local layer member bestLayer bestMember
      bestLayer=""
      bestMember=""

      rm -rf load stage
      mkdir -p load stage
      (
        cd load
        bsdtar -xf "$image_tar"

        # extract the layer files
        layers="$(jq -r --arg tag "1password/$binary:$version" '
          map(select(.RepoTags and (.RepoTags | any(endswith($tag)))))
          | .[0].Layers
          | .[]
        ' manifest.json)"

        # find the latest layer that contains the binary
        for layer in $layers; do
          member="$(bsdtar -tf "$layer" 2>/dev/null | grep -m1 -E "(^|/)usr/bin/$binary\$" || true)"
          if test -n "$member"; then
            bestLayer="$layer"
            bestMember="$member"
          fi
        done

        if test -z "$bestLayer"; then
          echo "fatal: usr/bin/$binary not found in any layer" >&2
          exit 1
        fi

        bsdtar --no-same-owner -C ../stage -xf "$bestLayer" "$bestMember"
      )

      mkdir -p "$out/bin"
      install -m 0755 "stage/usr/bin/$binary" "$out/bin/$binary"
    }

    extract_binary "$apiImageSrc" connect-api
    extract_binary "$syncImageSrc" connect-sync

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;

    tests = {
      connect-api = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "connect-api --version";
      };
      connect-sync = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "connect-sync --version";
      };
    };
  };

  meta = {
    description = "1Password Connect server";
    homepage = "https://www.1password.dev/connect";
    changelog = "https://github.com/1Password/connect/blob/main/CHANGELOG.md";
    # no license file upstream
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ xelacodes ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
