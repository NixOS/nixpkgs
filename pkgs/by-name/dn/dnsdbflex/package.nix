{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  jansson,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dnsdbflex";
  version = "1.0.7";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "dnsdbflex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+6Qrhkfm824/F/LBw4VZmeZUeTEriIHak5D4ryaiGJQ=";
  };

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "dnsdbflex -v";
    };
  };

  nativeBuildInputs = [
    curl # curl-config
  ];

  buildInputs = [
    curl
    jansson
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dnsdbflex $out/bin
    mkdir -p $out/man/man1
    cp dnsdbflex.man $out/man/man1/dnsdbflex.1
    runHook postInstall
  '';

  extraOutputsToInstall = [ "man" ];

  meta = {
    description = "Command line tool to use the DNSDB Flexible Search API extensions";
    homepage = "https://github.com/farsightsec/dnsdbflex";
    changelog = "https://github.com/farsightsec/dnsdbflex/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "dnsdbflex";
    platforms = lib.platforms.unix;
  };
})
