{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "managarr";
  version = "0.8.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AZaQXmo61BVsQGqHX5S+34pxEjDbxGMpmGsDewlyWcg=";
  };

  cargoHash = "sha256-A0gA56I+3vsGH0i6joXCsZiLjGct9m1F/Wx/pT2Mjws=";

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
