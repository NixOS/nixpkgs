{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  kaleido,
  testers,
}:
let
  version = "0.2.1";
  os = if stdenv.isLinux then "linux" else "mac";
  arch =
    if stdenv.isx86_64 then
      "x64"
    else if stdenv.isAarch64 then
      "arm64"
    else
      throw "Unsupported architecture";
  url = "https://github.com/plotly/Kaleido/releases/download/v${version}/kaleido_${os}_${arch}.zip";
  hashes = {
    x86_64-linux = "sha256-M46AZrGq8+9hTRSC0Rve+TwJVLIeSl764l+p19mUUZ8=";
    aarch64-linux = "sha256-2XAkv/TiN2KXk950HE8m+mU6CL1GcsG3OZAbs9IMnNk=";
    x86_64-darwin = "sha256-3ltsUa0sa1KpCPZImo56VPM0QSxPQ/juBdtl8zRpscE=";
    aarch64-darwin = "sha256-TzKbKop5/YIUjoGMEBeXGeMcOpEnPlGVCtpsbEJYGC0=";
  };
in
stdenv.mkDerivation rec {
  pname = "kaleido";
  inherit version;

  src = fetchzip {
    inherit url;
    hash = hashes.${stdenv.hostPlatform.system};
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  runtimeDependencies = [ libGL ];

  installPhase =
    ''
      mkdir -p $out/bin
      cp $src/bin/kaleido $out/bin/kaleido
    ''
    + lib.optionalString stdenv.isLinux ''
      mkdir -p $out/share/

      mkdir -p $out/share/fonts
      cp -r $src/etc/fonts/* $out/share/fonts/

      mkdir -p $out/share/xdg
      cp -r $src/xdg/* $out/xdg/

      mkdir -p $out/lib
      cp -r $src/lib/* $out/lib/

      wrapProgram "$out/bin/kaleido" \
        --prefix FONTCONFIG_PATH : "$out/share/fonts" \
        --prefix XDG_DATA_HOME : "$out/share/xdg"
    '';

  passthru = {
    tests.version = testers.testVersion { package = kaleido; };
  };

  meta = {
    homepage = "https://github.com/plotly/Kaleido";
    description = "Popcorn anime scraper/downloader + trackma wrapper";
    changelog = "https://github.com/plotly/Kaleido/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "kaleido";
  };
}
