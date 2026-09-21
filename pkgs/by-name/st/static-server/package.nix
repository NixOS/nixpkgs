{
  lib,
  buildGoModule,
  fetchFromGitHub,
  curl,
  openssl,
  stdenv,
  testers,
  static-server,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "static-server";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "static-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4VfysN1VVMKXgtnQGCluvAKrdOpFeccIl+OiWF9T/Uw=";
  };

  vendorHash = "sha256-1p3dCLLo+MTPxf/Y3zjxTagUi+tq7nZSj4ZB/aakJGY=";

  patches = [
    # patch out debug.ReadBuidlInfo since version information is not available with buildGoModule
    (replaceVars ./version.patch {
      inherit (finalAttrs) version;
    })
  ];

  nativeCheckInputs = [
    curl
    openssl
  ];

  # the certificate bundled with the tests expired in 2025, so regenerate it
  preCheck = ''
    openssl ecparam -name prime256v1 -genkey -noout -out testdata/datafiles/key.pem
    openssl req -x509 -new -key testdata/datafiles/key.pem -sha256 -days 36500 \
      -subj "/O=Acme Co" -addext "subjectAltName=IP:127.0.0.1" \
      -out testdata/datafiles/cert.pem
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  # tests sometimes fail with SIGQUIT on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    version = testers.testVersion {
      package = static-server;
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple, zero-configuration HTTP server CLI for serving static files";
    homepage = "https://github.com/eliben/static-server";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.novalkun ];
    mainProgram = "static-server";
  };
})
