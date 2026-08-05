{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  testers,
  pname,
  version,
  meta,
}:
let
  arch =
    {
      x86_64-linux = "x86_64-unknown-linux-gnu";
      aarch64-linux = "aarch64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-${arch}.tar.gz";
    hash =
      {
        x86_64-linux = "sha256-9cW/xUA9p0LEYI3/j4MGPVZvcyJpV1JYKYBuHur4sTM=";
        aarch64-linux = "sha256-zg141Dp+jHwAqzoaCNvOoC7ZFeAX+cO8HZF5W7wz1Qs=";
      }
      .${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    install -Dm755 elio -t $out/bin
    install -Dm644 packaging/linux/elio.desktop -t $out/share/applications
    cp -r packaging/linux/icons $out/share/icons

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = meta // {
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
