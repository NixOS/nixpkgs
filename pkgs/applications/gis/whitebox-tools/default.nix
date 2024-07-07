{
  lib,
  stdenv,
  cmake,
  rustPlatform,
  pkg-config,
  fetchFromGitHub,
  atk,
  gtk3,
  glib,
  openssl,
  Security,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    hash = "sha256-kvtfEEydwonoDux1VbAxqrF/Hf8Qh8mhprYnROGOC6g=";
  };

  cargoHash = "sha256-6v/3b6BHh/n7M2ZhLVKRvv0Va2xbLUSsxUb5paOStbQ=";

  buildInputs = [
    atk
    glib
    gtk3
    openssl
  ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    description = "Advanced geospatial data analysis platform";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mpickering ];
  };
}
