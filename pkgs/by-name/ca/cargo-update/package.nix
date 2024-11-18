{ lib
, rustPlatform
, fetchCrate
, cmake
, installShellFiles
, pkg-config
, ronn
, curl
, libgit2
, libssh2
, openssl
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "16.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jLv/9Fvg+1HNIhfm0D/vvMR9J+Enztj9rXQE1kZITGI=";
  };

  cargoHash = "sha256-rwXpQkL6ysMBraLIMk2zQe0vmb9uuePWufBjRVzaBOA=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    ronn
  ];

  buildInputs = [
    curl
    libgit2
    libssh2
    openssl
    zlib
  ];

  postBuild = ''
    # Man pages contain non-ASCII, so explicitly set encoding to UTF-8.
    HOME=$TMPDIR \
    RUBYOPT="-E utf-8:utf-8" \
      ronn -r --organization="cargo-update developers" man/*.md
  '';

  postInstall = ''
    installManPage man/*.1
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    changelog = "https://github.com/nabijaczleweli/cargo-update/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli Br1ght0ne johntitor matthiasbeyer ];
  };
}
