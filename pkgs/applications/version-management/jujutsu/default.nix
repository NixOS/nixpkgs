<<<<<<< HEAD
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
=======
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, dbus
, sqlite
, Security
, SystemConfiguration
, libiconv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, testers
, jujutsu
}:

rustPlatform.buildRustPackage rec {
  pname = "jujutsu";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-FczlSBlLhLIamLiY4cGVAoHx0/sxx+tykICzedFbbx8=";
  };

  cargoHash = "sha256-PydDgXp47KUSLvAQgfO+09lrzTnBjzGd+zA5f/jZfRc=";

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pkg-config
  ];

  buildInputs = [
    openssl
<<<<<<< HEAD
    zstd
    libgit2
    libssh2
=======
    dbus
    sqlite
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

<<<<<<< HEAD
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
=======
  passthru.tests = {
    version = testers.testVersion {
      package = jujutsu;
      command = "jj --version";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  meta = with lib; {
    description = "A Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/martinvonz/jj";
    changelog = "https://github.com/martinvonz/jj/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ _0x4A6F thoughtpolice ];
=======
    maintainers = with maintainers; [ _0x4A6F ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "jj";
  };
}
