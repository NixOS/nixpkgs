{ stdenv
, lib
, fetchzip
, fetchpatch
, rustPlatform

# native build inputs
, pkg-config
, installShellFiles
, makeWrapper
, mandoc
, rustfmt
, file

# build inputs
, openssl
, dbus
, sqlite

# runtime deps
, gpgme
, gnum4
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.8.8";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-XOUOIlFKxI7eL7KEEfLyYTsNqc2lc9sJNt9RqPavuW8=";
  };

    cargoPatches = [
    (fetchpatch {
      # https://git.meli-email.org/meli/meli/issues/522
      # https://git.meli-email.org/meli/meli/issues/524
      name = "fix test_fd_locks() on platforms without OFD support";
      url = "https://git.meli-email.org/meli/meli/commit/b7e215f9c238f8364e2a1f0d10ac668d0cfe91ad.patch";
      hash = "sha256-227vnFuxhQ0Hh5A/J8y7Ei89AxbNXReMn3c3EVRN4Tc=";
    })
  ];

  cargoHash = "sha256-SMvpmWEHUWo0snR/DiUmfZJnXy1QtVOowO8CErM9Xjg=";

  # Needed to get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR=1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
    mandoc
    (rustfmt.override { asNightly = true; })
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ];

  nativeCheckInputs = [
    file
    gnum4
  ];

  postInstall = ''
    installManPage meli/docs/*.{1,5,7}

    wrapProgram $out/bin/meli \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gpgme ]} \
      --prefix PATH : ${lib.makeBinPath [ gnum4 ]}
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    "--skip=test_cli_subcommands" # panicking due to sandbox
  ];

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
