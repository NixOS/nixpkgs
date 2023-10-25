{ stdenv
, lib
, fetchgit
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
, gnum4
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.8.2";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = "v${version}";
    hash = "sha256-iEHTFofga/HV/1jSAqTsqV55zC22tqI7UW7m4PZgz0M=";
  };

  cargoHash = "sha256-ijlivyBezLECBSaWBYVy9tVcSO8U+yGDQyU4dIATR6k=";

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
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer ];
    platforms = platforms.linux;
  };
}
