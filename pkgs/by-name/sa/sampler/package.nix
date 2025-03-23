{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  darwin,
  alsa-lib,
  stdenv,
}:

buildGoModule rec {
  pname = "sampler";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sqshq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-H7QllAqPp35wHeJ405YSfPX3S4lH0/hdQ8Ja2OGLVtE=";
  };

  patches = [
    # fix build with go 1.17
    (fetchpatch {
      url = "https://github.com/sqshq/sampler/commit/97a4a0ebe396a780d62f50f112a99b27044e832b.patch";
      hash = "sha256-c9nP92YHKvdc156OXgYVoyNNa5TkoFeDa78WxOTR9rM=";
    })
  ];

  vendorHash = "sha256-UZLF/oJbWUKwIPyWcT1QX+rIU5SRnav/3GLq2xT+jgk=";

  doCheck = false;

  subPackages = [ "." ];

  buildInputs =
    lib.optional stdenv.hostPlatform.isLinux alsa-lib
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.OpenAL
    ];

  meta = with lib; {
    description = "Tool for shell commands execution, visualization and alerting";
    homepage = "https://sampler.dev";
    license = licenses.gpl3;
    maintainers = with maintainers; [ uvnikita ];
    mainProgram = "sampler";
  };
}
