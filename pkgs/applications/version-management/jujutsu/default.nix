{ stdenv
, lib
, fetchFromGitHub
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
, fetchpatch
, installShellFiles
, nix-update-script
, testers
, jujutsu
}:

rustPlatform.buildRustPackage rec {
  pname = "jujutsu";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    sha256 = "sha256-5RN2xaH591/83iNXRcW9i/TyU5ndPZq3P/BesHM9I6w=";
  };

  cargoHash = "sha256-G4W3GeTWTuIZO1PupuZ0hACwhNoNBQhULyT9f6qVckg=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    # enable 'packaging' feature, which enables extra features such as support
    # for watchman
    "packaging"
  ];

  cargoBuildFlags = [ "--bin" "jj" ]; # don't install the fake editors
  useNextest = true; # nextest is the upstream integration framework
  ZSTD_SYS_USE_PKG_CONFIG = "1";    # disable vendored zlib
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

  postInstall = ''
    $out/bin/jj util mangen > ./jj.1
    installManPage ./jj.1

    installShellCompletion --cmd jj \
      --bash <($out/bin/jj util completion --bash) \
      --fish <($out/bin/jj util completion --fish) \
      --zsh <($out/bin/jj util completion --zsh)
  '';

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
    description = "A Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    changelog = "https://github.com/martinvonz/jj/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F thoughtpolice ];
    mainProgram = "jj";
  };
}
