{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo";
  version = "1.0.39";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-U3uVQiALtI7aWkIPQyHxSzMTD6AjAMoOEjkbPO07SdA=";
  };

  # clipboard functionality not working on Darwin
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  vendorHash = null;

  meta = {
    description = "Print x509 certificate info";
    mainProgram = "certinfo";
    homepage = "https://github.com/pete911/certinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakuzure ];
  };
})
