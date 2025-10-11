{
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  fetchurl,
  git,
  nodejs,
  pkg-config,
  pnpm,
  python3,
  stdenv,
}:

let
  glideVersion = "0.1.51a";
  glideRevision = "a710ac4a5865";
  firefoxVersion = "144.0b8";

  firefoxSrc = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha512-8/hkzJZqrNa6MqIwbejFFGyVZgQ3W5at4CJzNW8rkQb2XdsHMu0kAj4rD3y3kbqoywQBWAmUbBi48UnB2l5k3A==";
  };

  patchedSrc = stdenv.mkDerivation (finalAttrs: {
    pname = "firefox-glide-browser-src-patched";
    version = glideVersion;
    GLIDE_REVISION = glideRevision;

    src = fetchFromGitHub {
      owner = "glide-browser";
      repo = "glide";
      tag = glideVersion;
      hash = "sha256-NsMgVQZiydlYHZCvPZdRtopMqmihD4E06JVqNftJ5oM=";
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
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-0gNGudV+CUk7WpHZQFBy4pk02H0PuKFvSH0cA6omx9M=";
    };

    buildPhase = ''
      runHook preBuild

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
