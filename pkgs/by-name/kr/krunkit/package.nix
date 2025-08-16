{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  asciidoctor,
  buildah,
  buildah-unwrapped,
  cargo,
  libkrun,
  makeWrapper,
  rustc,
  sigtool,
}:

stdenv.mkDerivation rec {
  pname = "krunkit";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oT9/0EonR2GZRAB5fro0rmBZNx3hFszvy6XOqNu+buE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-3nQC2bZLXHD1/ugcm30fBv8Cx1xNuC5r0AimXk8LM7M=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    asciidoctor
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ sigtool ];

  buildInputs = [
    libkrun
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  env.NIX_LDFLAGS = "-L${libkrun}/lib";

  postInstall = ''
    mkdir -p $out/share/krunkit/containers
    install -D -m755 ${buildah-unwrapped.src}/docs/samples/registries.conf $out/share/krunkit/containers/registries.conf
    install -D -m755 ${buildah-unwrapped.src}/tests/policy.json $out/share/krunkit/containers/policy.json
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.hostPlatform.isDarwin;

  postFixup = ''
    wrapProgram $out/bin/krunkit \
      --prefix PATH : ${lib.makeBinPath [ buildah ]} \
  '';

  meta = {
    description = "Launch configurable virtual machines with libkrun";
    homepage = "https://github.com/containers/krunkit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
    platforms = libkrun.meta.platforms;
    mainProgram = "krunkit";
  };
}
