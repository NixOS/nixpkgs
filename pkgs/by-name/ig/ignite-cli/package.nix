{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  go,
  buf,
}:

buildGoModule (finalAttrs: {
  pname = "ignite-cli";
  version = "29.8.0";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "ignite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-joY88Tum3xeRLqeQ1OMJWS2Hzud3Qt9Oic4k7dEpo7o=";
  };

  vendorHash = "sha256-6UjeiTpRKcKX9vcNr0Qt8cw4tUkg7fsEL5cXSQWTlBM=";

  subPackages = [
    "ignite/cmd/ignite"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # Many tests require access to either executables, state or networking
  doCheck = false;

  # Required for wrapProgram
  allowGoReference = true;

  # Required for commands like `ignite version`, `ignite network` and others
  postFixup = ''
    wrapProgram $out/bin/ignite --prefix PATH : ${
      lib.makeBinPath [
        go
        buf
      ]
    }
  '';

  meta = {
    homepage = "https://ignite.com/";
    changelog = "https://github.com/ignite/cli/releases/tag/v${finalAttrs.version}";
    description = "All-in-one platform to build, launch, and maintain any crypto application on a sovereign and secured blockchain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "ignite";
  };
})
