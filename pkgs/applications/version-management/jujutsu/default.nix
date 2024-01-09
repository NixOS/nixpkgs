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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    hash = "sha256-UFe4hVzn/jN22KtTuTcyNpseJdgIkmh9/eAJdSObfYU=";
  };

  cargoHash = "sha256-WY8egnsyCuTLHd2Jnw+RLNd2LUOorHlnHVGLxtR5exQ=";

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
