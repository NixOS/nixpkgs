{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  fetchurl,
  rustPlatform,
  pkg-config,
  oniguruma,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage {
  pname = "stract";
  version = "0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "StractOrg";
    repo = "stract";
    rev = "ecb495a66cf6c2f66d817803df38385a3001a38d";
    hash = "sha256-UeIziIihDCjGoz2IdfROnO9/N82S4yextnF4Sbtrn24=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-UArPGrcEfFZBOZ4Tv7NraqPzdMtyJXVFsfUM32eSGic=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
    openssl
    zstd
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SWAGGER_UI_DOWNLOAD_URL =
      let
        # When updating:
        # - Look for the version of `utoipa-swagger-ui` at:
        #   https://github.com/StractOrg/stract/blob/<STRACT-REV>/Cargo.toml#L183
        # - Look at the corresponding version of `swagger-ui` at:
        #   https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-<UTOPIA-SWAGGER-UI-VERSION>/utoipa-swagger-ui/build.rs#L21-L22
        swaggerUiVersion = "5.17.12";
        swaggerUi = fetchurl {
          url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${swaggerUiVersion}.zip";
          hash = "sha256-HK4z/JI+1yq8BTBJveYXv9bpN/sXru7bn/8g5mf2B/I=";
        };
      in
      "file://${swaggerUi}";
  };

  # swagger-ui will once more be copied in the target directory during the check phase
  # Not deleting the existing unpacked archive leads to a `PermissionDenied` error
  preCheck = ''
    rm -rf target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Open source web search engine";
    longDescription = ''
      Stract is an open source web search engine targeted towards tinkerers and
      developers, with an official instance hosted at stract.com
    '';
    homepage = "https://github.com/StractOrg/stract";
    license = lib.licenses.agpl3Only;
    maintainers =
      with lib.maintainers;
      [
        ailsa-sun
      ]
      ++ lib.teams.ngi.members;
  };
}
