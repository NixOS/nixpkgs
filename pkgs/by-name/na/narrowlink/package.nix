{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "narrowlink";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "narrowlink";
    repo = "narrowlink";
    rev = finalAttrs.version;
    hash = "sha256-tCnrbvgCFW+YxZuDauuZb2E48dwnzSZvUJQ9Nzqc3xw=";
  };

  cargoHash = "sha256-4S3mP8ZruFZtl/ZqVXKewIA0K3OcAspUpDz3eLBgcu8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "Self-hosted solution to enable secure connectivity between devices across restricted networks like NAT or firewalls";
    homepage = "https://github.com/narrowlink/narrowlink";
    license = with lib.licenses; [
      agpl3Only
      mpl20
    ]; # the gateway component is AGPLv3, the rest is MPLv2
    maintainers = [ ];
    mainProgram = "narrowlink";
  };
})
