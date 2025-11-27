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
  glideVersion = "0.1.58a";
  glideRevision = "c6130298e247";
  firefoxVersion = "148.0b4";

  firefoxSrc = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha512-L232/GMjkRxW83EIVBxDTls0Kyj8Zopvw5yFmAdPXY4ftMe5z8MNhzfJuzM6+pcRy7MqY3ohLzdIzTIR4zWtVg==";
  };

  patchedSrc = stdenv.mkDerivation (finalAttrs: {
    pname = "firefox-glide-browser-src-patched";
    version = glideVersion;
    GLIDE_REVISION = glideRevision;

    src = fetchFromGitHub {
      owner = "glide-browser";
      repo = "glide";
      tag = glideVersion;
      hash = "sha256-jBaRoBc821LyeogqBRkWgfvHQpvp4oWhgbnoI4aM+Ss=";
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
      hash = "sha256-zYYF2hsLf6rYBF0QLLC1k1qxNgngHdVVXGxdO/VeEXk=";
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
      GLIDE_FIREFOX_VERSION = firefoxVersion;
      MOZ_USER_DIR = "Glide Browser";
    }
    // lib.optionalAttrs stdenv.isDarwin {
      # note: might be redundant
      MOZ_MACBUNDLE_NAME = "Glide.app";
    }
  )
