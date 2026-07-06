{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "managarr";
  version = "0.7.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-10wM6OI3XqFQKyspJU6fqnE3GyzxNaquQlPjn3nS774=";
  };

  cargoHash = "sha256-7myysFoBYTosHPZ3gzSzXhN8+wbHHF/73b6wQqdlKe8=";

  nativeBuildInputs = [ perl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      IncredibleLaser
      darkalex
      nindouja
      kybe236
    ];
    mainProgram = "managarr";
  };
})
