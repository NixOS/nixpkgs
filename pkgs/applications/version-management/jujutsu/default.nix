{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, rustPlatform
, Security
, SystemConfiguration
, pkg-config
, libiconv
, openssl
, gzip
, libssh2
, libgit2
, zstd
, installShellFiles
, nix-update-script
, testers
, jujutsu
}:

rustPlatform.buildRustPackage rec {
  pname = "jujutsu";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    hash = "sha256-1lONtpataRi0yE6LpN6oNnC3OAW918v8GFCUwinYJWI=";
  };

  cargoPatches = [
    # cargo: bump `git2` to 0.19.0
    (fetchpatch2 {
      url = "https://github.com/martinvonz/jj/commit/38f6ee89183d886e432472c5888908c9900c9c18.patch?full_index=1";
      hash = "sha256-BVcak7uIEhwoO0f9hf0GVKKSVmp/ueKD5C9F8J0iL3w=";
    })
  ];

  cargoHash = "sha256-FxcvLT0YnXcjDCKxuyijYsVSMLjx1glDzmFH5ctSx6s=";

  cargoBuildFlags = [ "--bin" "jj" ]; # don't install the fake editors
  useNextest = false; # nextest is the upstream integration framework, but is problematic for test skipping
  ZSTD_SYS_USE_PKG_CONFIG = "1";    # disable vendored zlib
  LIBGIT2_NO_VENDOR = "1"; # disable vendored libgit2
  LIBSSH2_SYS_USE_PKG_CONFIG = "1"; # disable vendored libssh2

  nativeBuildInputs = [
    gzip
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    zstd
    libgit2
    libssh2
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/jj util mangen > ./jj.1
    installManPage ./jj.1

    installShellCompletion --cmd jj \
      --bash <($out/bin/jj util completion bash) \
      --fish <($out/bin/jj util completion fish) \
      --zsh <($out/bin/jj util completion zsh)
  '';

  checkFlags = [
    # signing tests spin up an ssh-agent and do git checkouts
    "--skip=test_ssh_signing"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = jujutsu;
        command = "jj --version";
      };
    };
  };

  meta = with lib; {
    description = "Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    changelog = "https://github.com/martinvonz/jj/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F thoughtpolice ];
    mainProgram = "jj";
  };
}
