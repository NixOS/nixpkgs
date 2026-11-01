{
  stdenvNoCC,
  fetchurl,
  testers,
  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-aarch64-apple-darwin.tar.gz";
    hash = "sha256-h0wX5ytVYfpmj6dqrANLyareBklenrEBgVZXKbisSow=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 elio -t $out/bin
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = meta // {
    platforms = [ "aarch64-darwin" ];
  };
})
