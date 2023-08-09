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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "martinvonz";
    repo = "jj";
    rev = "v${version}";
    sha256 = "sha256-kbJWkCnb77VRKemA8WejaChaQYCxNiVMbqW5PCrDoE8=";
  };

  cargoHash = "sha256-qbCOVcKpNGWGonRAwPsr3o3yd+7qUTy3IVmC3Ifn4xE=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    # enable 'packaging' feature, which enables extra features such as support
    # for watchman
    "packaging"
  ];

  patches = [
    # this patch (hopefully!) fixes a very, very rare test failure that can
    # occasionally be cajoled out of Nix and GitHub CI builds. go ahead and
    # apply it to be safe.
    (fetchpatch {
      url = "https://github.com/martinvonz/jj/commit/8e7e32710d29010423f3992bb920aaf2a0fa04ec.patch";
      hash = "sha256-ySieobB1P/DpWOurcCb4BXoHk9IqrjzMfzdc3O5cTXk=";
    })
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
