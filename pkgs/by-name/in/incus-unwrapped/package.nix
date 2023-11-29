{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, acl
, cowsql
, hwdata
, libcap
, lxc
, pkg-config
, sqlite
, udev
, installShellFiles
, nix-update-script
, nixosTests
}:

buildGoModule rec {
  pname = "incus-unwrapped";
  version = "0.4.0";

  outputs = [ "out" "client" ];

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    hash = "sha256-crWepf5j3Gd1lhya2DGIh/to7l+AnjKJPR+qUd9WOzw=";
  };

  vendorHash = "sha256-YfUvkN1qUS3FFKb1wysg40WcJA8fT9SGDChSdT+xnkc=";

  patches = [
    # remove with > 0.4.0
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/c0200b455a1468685d762649120ce7e2bb25adc9.patch";
      hash = "sha256-4fiSv6GcsKpdLh3iNbw3AGuDzcw1EadUvxtSjxRjtTA=";
    })
  ];

  postPatch = ''
    substituteInPlace internal/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = if stdenv.isLinux then [
    "cmd/incus-agent"
    "cmd/incus-migrate"
    "cmd/lxd-to-incus"
    "test/mini-oidc"
  ] else [
    # non-linux only supports the client, installed in postBuild
    ".*"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    lxc
    acl
    libcap
    cowsql.dev
    sqlite
    udev.dev
  ];

  ldflags = [ "-s" "-w" ];
  tags = [ "libsqlite3" ];

  # required for go-cowsql.
  CGO_LDFLAGS_ALLOW = "(-Wl,-wrap,pthread_create)|(-Wl,-z,now)";

  postBuild = ''
    ${lib.optionalString stdenv.isLinux "make incus-agent incus-migrate"}

    CGO_ENABLED=0 go install ./cmd/incus
  '';

  preCheck =
    let skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ]; in
    ''
      # Disable tests requiring local operations
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  postInstall = ''
    # use custom bash completion as it has extra logic for e.g. instance names
    installShellCompletion --bash --name incus ./scripts/bash/incus

    installShellCompletion --cmd incus \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)

    mkdir -p $client/bin
    mv $out/bin/incus $client/bin/
    mv $out/share $client/
  '';


  passthru = {
    tests.incus = nixosTests.incus;

    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "v\(.*\)"
       ];
     };
  };

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/incus-${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}
