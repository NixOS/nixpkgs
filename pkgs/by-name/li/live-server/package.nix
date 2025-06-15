{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "live-server";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    rev = "v${version}";
    hash = "sha256-0IP7F8+Vdl/h4+zcghRqowvzz6zjQYDTjMSZPuGOOj4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MMeeUoj3vYd1lv15N3+qjHbn991IVMhIUCMd0isCNhk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Local network server with live reload feature for static pages";
    downloadPage = "https://github.com/lomirus/live-server/releases";
    homepage = "https://github.com/lomirus/live-server";
    license = licenses.mit;
    mainProgram = "live-server";
    maintainers = [ maintainers.philiptaron ];
    platforms = platforms.unix;
  };
}
