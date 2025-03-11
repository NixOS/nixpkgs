{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
}:

let
  version = "23.1.14";
  pname = "cockroachdb";

  # For several reasons building cockroach from source has become
  # nearly impossible. See https://github.com/NixOS/nixpkgs/pull/152626
  # Therefore we use the pre-build release binary and wrap it with buildFHSUserEnv to
  # work on nix.
  # You can generate the hashes with
  # nix flake prefetch <url>
  srcs = {
    aarch64-linux = fetchzip {
      url = "https://binaries.cockroachdb.com/cockroach-v${version}.linux-arm64.tgz";
      hash = "sha256-cwczzmSKKQs/DN6WZ/FF6nJC82Pu47akeDqWdBMgdz0=";
    };
    x86_64-linux = fetchzip {
      url = "https://binaries.cockroachdb.com/cockroach-v${version}.linux-amd64.tgz";
      hash = "sha256-goCBE+zv9KArdoMsI48rlISurUM0bL/l1OEYWQKqzv0=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
buildFHSEnv {
  inherit pname version;

  runScript = "${src}/cockroach";

  extraInstallCommands = ''
    cp -P $out/bin/cockroachdb $out/bin/cockroach
  '';

  meta = with lib; {
    homepage = "https://www.cockroachlabs.com";
    description = "Scalable, survivable, strongly-consistent SQL database";
    license = with licenses; [
      bsl11
      mit
      cockroachdb-community-license
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [
      rushmorem
      thoughtpolice
    ];
  };
}
