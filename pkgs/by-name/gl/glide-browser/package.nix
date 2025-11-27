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
  glideVersion = "0.1.59a";
  glideRevision = "4e9a77a30d05";
  firefoxVersion = "148.0b15";

  firefoxSrc = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha512-WFOBiQUZO3qw2iGY4xdfA5p7jlY5mmuw7dUPAWh2b/BidVsOODVTZB2fbUq4tP24AuAgZdp2Qy0dTDlcjMGlQw==";
  };

  patchedSrc = stdenv.mkDerivation (finalAttrs: {
    pname = "firefox-glide-browser-src-patched";
    version = glideVersion;
    GLIDE_REVISION = glideRevision;

    src = fetchFromGitHub {
      owner = "glide-browser";
      repo = "glide";
      tag = glideVersion;
      hash = "sha256-bgLJ0OdDh5DgTwiKAeoDd9Q+MC1sXyqoQXG/YH8IPUo=";
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
      hash = "sha256-OF4XHIxC/gWmOc0f8xk/zc5Y8t1YZGMy7tA2yOHDpWQ=";
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
