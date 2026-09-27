{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nodejs-slim,
  pkg-config,
  vips,
  python3,
}:
buildNpmPackage (
  finalAttrs:
  let
    media = stdenv.mkDerivation {
      pname = "opengym-media";
      version = "0-unstable-2026-07-16";

      __structuredAttrs = true;

      src = fetchFromGitHub {
        owner = "hasaneyldrm";
        repo = "exercises-dataset";
        rev = "7455efae41b330c265e7cd4b78dfa848e7ce5ebd";
        hash = "sha256-bAit6zzd1Q1SPgb3ydjuZN78yXjRcgcIs+hH4gKNaxE=";
      };

      installPhase = ''
        mkdir -p $out/img $out/gif
        cp images/*.jpg $out/img/
        cp videos/*.gif $out/gif/
      '';
    };

    frontend = buildNpmPackage {
      pname = "opengym-web";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;

      sourceRoot = "${finalAttrs.src.name}/frontend";
      npmDepsHash = "sha256-LZKOsep2myfbMnqfH19D7wHH1yJINlSooz5gGoo8hNk=";

      makeCacheWritable = true;

      nativeBuildInputs = [
        pkg-config
        python3
      ];
      buildInputs = [ vips ];

      buildPhase = ''
        npm run build
      '';

      installPhase = ''
        mkdir -p $out
        cp -R dist/* $out/
      '';
    };
  in
  {
    pname = "opengym";
    version = "1.3.8";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "DuarteSantos8";
      repo = "openGym";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/8+lGPEXRcn2/BIUC7uyJkn3iYrr4xJRWOp+e7V3VaE=";
    };

    sourceRoot = "${finalAttrs.src.name}/api";
    npmDepsHash = "sha256-17sKhtFSCOYBXuqFyhMsAehDLYDsmkG9FcFct+tsqEw=";

    nativeBuildInputs = [ makeWrapper ];

    dontNpmBuild = true;

    installPhase = ''
      mkdir -p $out/lib/opengym $out/bin
      cp -r . $out/lib/opengym/

      makeWrapper ${nodejs-slim}/bin/node $out/bin/opengym \
        --add-flags "$out/lib/opengym/server.js" \
        --set NODE_ENV production
    '';

    passthru = {
      inherit frontend media;
      updateScript = ./update.sh;
    };

    meta = {
      description = "Self-hosted workout tracker";
      homepage = "https://github.com/DuarteSantos8/openGym";
      mainProgram = "opengym";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ luuumine ];
      platforms = lib.platforms.linux;
    };
  }
)
