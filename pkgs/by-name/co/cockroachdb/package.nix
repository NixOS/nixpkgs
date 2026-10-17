{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
}:

let
  version = "25.4.2";
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
      hash = "sha256-EyVCPJ+kIrR5LDteFsgJ7/L28/n+NiUnP7H1mCPC5nQ=";
    };
    x86_64-linux = fetchzip {
      url = "https://binaries.cockroachdb.com/cockroach-v${version}.linux-amd64.tgz";
      hash = "sha256-+ltnhAFh4z3TrMr1FQ+WT8CAiep4/m7b7OxbhfSFAPk=";
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

  meta = {
    homepage = "https://www.cockroachlabs.com";
    description = "Scalable, survivable, strongly-consistent SQL database";
    license = with lib.licenses; [
      bsl11
      mit
      cockroachdb-community-license
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      rushmorem
      thoughtpolice
    ];
  };
}
