{
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  fetchurl,
  git,
  nodejs,
  pkg-config,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  python3,
  stdenv,
}:

let
  glideVersion = "0.1.62a";
  glideRevision = "e89e9a621993";
  firefoxVersion = "152.0b2";

  firefoxSrc = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha512-DoHR3+TI+nSCZpo+EEV16qzzxnHWelGNoSrJCZiQiK8etxaAFQQsSWfAQsHVpxXtVbjgxUmcPAU/5MQ6O0Z16A==";
  };

  patchedSrc = stdenv.mkDerivation (finalAttrs: {
    pname = "firefox-glide-browser-src-patched";
    version = glideVersion;
    GLIDE_REVISION = glideRevision;

    src = fetchFromGitHub {
      owner = "glide-browser";
      repo = "glide";
      tag = glideVersion;
      hash = "sha256-g5QzxF6v7NzwqfZC0oOkebjQjsvwTGgaitXQjK1Yqs4=";
    };

    postUnpack = ''
      mkdir -p source/engine
      # note: the firefox tar unpacks to firefox-$version/
      tar xf ${firefoxSrc} --strip-components=1 -C source/engine
    '';

    nativeBuildInputs = [
      git
      nodejs
      python3
      pkg-config
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 3;
      hash = "sha256-P1ROOZC4F00WqAfkN2hcvcHfJ2l+2rfWVUdJOQ9+wIg=";
    };

    buildPhase = ''
      runHook preBuild

      # replace dprint with a no-op script as it's just used for formatting a
      # generated .d.ts file, which is not worth adding it as a dependency for
      rm node_modules/.bin/dprint
      echo '#!/bin/sh' > node_modules/.bin/dprint
      chmod +x node_modules/.bin/dprint

      patchShebangs scripts/

      pnpm bootstrap --offline
      # bootstrap includes a default mozconfig but that can mess with options that `buildMozillaMach` sets, so just remove it.
      rm engine/mozconfig

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r engine $out

      cd $out
      for i in $(find . -type l); do
        realpath=$(readlink $i)
        rm $i
        cp $realpath $i
      done

      runHook postInstall
    '';

    dontFixup = true;
  });
in
(
  (buildMozillaMach {
    pname = "glide-browser";
    version = firefoxVersion;
    packageVersion = glideVersion;
    applicationName = "Glide";
    binaryName = "glide";
    branding = "browser/branding/glide";

    requireSigning = false;
    allowAddonSideload = true;

    src = patchedSrc;

    extraConfigureFlags = [
      "--disable-lto"
      "--with-app-basename=Glide"
    ];

    meta = {
      description = "Extensible and keyboard-focused web browser built on Firefox";
      homepage = "https://glide-browser.app/";
      downloadPage = "https://glide-browser.app/#download";
      changelog = "https://glide-browser.app/changelog#${glideVersion}";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        RobertCraigie
        pyrox0
      ];
      platforms = lib.platforms.unix;
      mainProgram = "glide";
    };
  }).override
  {
    pgoSupport = false;
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
).overrideAttrs
  (
    prev:
    {
      strictDeps = true;
      __structuredAttrs = true;

      GLIDE_FIREFOX_VERSION = firefoxVersion;
      MOZ_USER_DIR = "Glide Browser";

      # these revert patches don't apply.
      patches = lib.filter (
        p:
        !lib.elem (p.name or (builtins.baseNameOf p)) [
          "73cbb9ff0fdbf8b13f38d078ce01ef6ec0794f9c.patch"
          "c1cd0d56e047a40afb2a59a56e1fd8043e448e05.patch"
        ]
      ) prev.patches;
    }
    // lib.optionalAttrs stdenv.isDarwin {
      # note: might be redundant
      MOZ_MACBUNDLE_NAME = "Glide.app";
    }
  )
