{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  bun,
  nodejs,
  nix-update-script,
}:

let
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "smolsonic";
    tag = "v${version}";
    hash = "sha256-RzvhjLfJHVOTnwCEdSzZz/JoGU4HeGy813G1DUDGi8Q=";
  };

  s3webuiNodeModules = stdenv.mkDerivation {
    pname = "smolsonic-s3webui-node-modules";
    inherit version src;

    sourceRoot = "${src.name}/s3webui";

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export HOME=$(mktemp -d)
      bun install --frozen-lockfile --no-progress --ignore-scripts
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mv node_modules $out
      runHook postInstall
    '';

    dontFixup = true;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash =
      {
        x86_64-linux = "sha256-yKUGN1F8I1S6M5GgXeVA5y/u2gm8vYjyKxGLNO1nB90=";
        aarch64-linux = "sha256-RApkHwuTtdLTo+2lgA9Z/47QTwwiE9WJlZ0Y+NI5Bqo=";
        aarch64-darwin = "sha256-VuAM4wkTAL8kIE0KseAC79F4+qLbLzR4g3AWiQjwaT0=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "smolsonic: unsupported system ${stdenv.hostPlatform.system}");
  };

  s3webui = stdenv.mkDerivation {
    pname = "smolsonic-s3webui";
    inherit version src;

    sourceRoot = "${src.name}/s3webui";

    nativeBuildInputs = [
      bun
      nodejs
    ];

    configurePhase = ''
      runHook preConfigure
      cp -r ${s3webuiNodeModules} node_modules
      chmod -R u+w node_modules
      patchShebangs node_modules
      export HOME=$(mktemp -d)
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      bun run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "smolsonic";
  inherit version src;

  __structuredAttrs = true;

  cargoHash = "sha256-dgM0VpSnCiIPOx/JZ+SrjRgnYxQ5hhObsBU5nn6wZ+0=";

  preBuild = ''
    cp -r ${s3webui} s3webui/dist
    chmod -R u+w s3webui/dist
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny self-hosted music and video server speaking the Subsonic and Jellyfin APIs";
    longDescription = ''
      smolsonic is a single-binary music and video server. Point it at a folder
      of media, set a username and password in one TOML file, and any Subsonic
      or Jellyfin-compatible client can browse and stream your library. It
      stores its index in SQLite and needs no external services. Optional
      extras include an S3-compatible upload API with a web admin UI, UPnP/DLNA
      discovery, mDNS/Zeroconf announcement, and ListenBrainz scrobbling.
    '';
    homepage = "https://github.com/tsirysndr/smolsonic";
    changelog = "https://github.com/tsirysndr/smolsonic/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "smolsonic";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
