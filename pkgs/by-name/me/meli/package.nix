{ stdenv
, lib
, fetchzip
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
  version = "0.8.6";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-7lSxXv2i8B6vRWIJqMiXlMqHH6fmgACy9X5qNKuj+IU=";
  };

  cargoHash = "sha256-vZkMfaALnRBK9ZwMB2uvvJgQq+BdUX7enNnr9t5H+MY=";

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
    "--skip=conf::test_config_parse"        # panicking due to sandbox
    "--skip=smtp::test::test_smtp"          # requiring network
    "--skip=utils::xdg::query_default_app"  # doesn't build
    "--skip=utils::xdg::query_mime_info"    # doesn't build
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer ];
    platforms = platforms.linux;
  };
}
