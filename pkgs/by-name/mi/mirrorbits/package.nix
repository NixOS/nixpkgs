{
  lib,
  versionCheckHook,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  zlib,
  geoip,
}:

buildGoModule (finalAttrs: {
  pname = "mirrorbits";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "etix";
    repo = "mirrorbits";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PqPE/PgIyQylbYoABC/saxLF83XjgRAS0QimragJ8P8=";
  };

  postPatch = ''
    rm -rf vendor
  '';

  vendorHash = "sha256-cdD9RvOtgN/SHtgrtrucnUI+nnO/FabUyPRdvgoL44o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zlib
    geoip
  ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/etix/mirrorbits/core.VERSION=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Geographical download redirector for distributing files efficiently across a set of mirrors";
    homepage = "https://github.com/etix/mirrorbits";
    longDescription = ''
      Mirrorbits is a geographical download redirector written in Go for
      distributing files efficiently across a set of mirrors. It offers
      a simple and economic way to create a Content Delivery Network
      layer using a pure software stack. It is primarily designed for
      the distribution of large-scale Open-Source projects with a lot
      of traffic.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
    mainProgram = "mirrorbits";
  };
})
