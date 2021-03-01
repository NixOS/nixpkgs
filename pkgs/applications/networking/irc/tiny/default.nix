{ stdenv
, lib
, rustPlatform
, fetchpatch
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "07a50shv6k4fwl2gmv4j0maxaqqkjpwwmqkxkqs0gvx38lc5f7m7";
  };

  cargoSha256 = "009jqizj4qg1bqslna35myxcark40hwlqsz58fbps9nsgp1i0hq2";

  cargoPatches = [
    # Fix Cargo.lock version. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/osa1/tiny/commit/b1caf48a6399dad8875de1d965d1ad445e49585d.patch";
      sha256 = "1zkjhx94nwmd69cfwwwzg51ipcwq01wyvgsmn0vq7iaa2h0d286i";
    })
  ];

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals stdenv.isLinux [ dbus openssl ] ++ lib.optional stdenv.isDarwin Foundation;

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
