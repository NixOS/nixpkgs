{ stdenv
, lib
, rustPlatform
, fetchpatch
, fetchFromGitHub
, pkg-config
, dbus
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.5.2-test";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "09i0vkf9k4qga588wmz1z2mnnjz57bziff98vhwdvlw8dlidp7ip";
  };

  cargoSha256 = "02iwc14df0vflp8l5gsaj7sqc08lmvsbs64bi1xaqrnvp0li8bvx";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals stdenv.isLinux [ dbus openssl ];

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
