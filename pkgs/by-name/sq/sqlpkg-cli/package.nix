{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqlpkg-cli";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "nalgeon";
    repo = "sqlpkg-cli";
    tag = version;
    hash = "sha256-qytqTaoslBcoIn84tSiLABwRcnY/FsyWYD3sugGEYB0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv -v $out/bin/cli $out/bin/sqlpkg
  '';

  preCheck = ''
    export HOME="$TMP"
  '';

  meta = {
    description = "SQLite package manager";
    homepage = "https://github.com/nalgeon/sqlpkg-cli";
    changelog = "https://github.com/nalgeon/sqlpkg-cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbsds ];
    mainProgram = "sqlpkg";
    platforms = lib.platforms.unix;
    badPlatforms = [
      "aarch64-linux" # assets_test.go:44: BuildAssetPath: unexpected error unsupported platform: linux-arm64
      "x86_64-darwin" # assets_test.go:44: BuildAssetPath: unexpected error unsupported platform: darwin-amd64
      "aarch64-darwin" # install_test.go:22: installation error: failed to dequarantine files: exec: "xattr": executable file not found in $PATH
    ];
  };
}
