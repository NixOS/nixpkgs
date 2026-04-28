{
  lib,
  stdenv,
  buildMozillaMach,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  nix-update-script,
}:
let
  version = "15.0.10";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvad-browser";
    tag = version;
    hash = "sha256-dNEHcyHGYD7rVK7vbqUk/LHXlD8Kn/OvJ/nm72CQXa8=";
  };

  mullvadbrowser-assets = fetchzip {
    urls = [
      "https://cdn.mullvad.net/browser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
      "https://github.com/mullvad/mullvad-browser/releases/download/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
      "https://archive.torproject.org/tor-package-archive/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
      "https://dist.torproject.org/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
      "https://tor.eff.org/dist/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
    ];
    hash = "sha256-qAJ+ybstAS0Eiu2DaJ4PhI5ntTNLIPIWeNhBUiZGtVc=";
  };
in
(
  (buildMozillaMach {
    pname = "mullvad-browser";
    inherit src;
    version = "140.9.0esr";
    packageVersion = version;

    applicationName = "Mullvad Browser";
    binaryName = "mullvad-browser";
    branding = "browser/branding/mb-release";

    extraConfigureFlags =
      lib.cli.toCommandLineGNU { } (
        {
          # our adaptations for nixpkgs
          with-base-browser-version = version;
          disable-base-browser-update = true;
          without-relative-data-dir = true;
          # default is "default", which is the same as "nightly"
          enable-update-channel = "release";

          # configs in browser/config/mozconfigs/base-browser
          disable-unverified-updates = true;
          enable-bundled-fonts = true;
          disable-parental-controls = true;
          enable-proxy-bypass-protection = true;
          disable-system-policies = true;
          disable-backgroundtasks = true;
          disable-legacy-profile-creation = true;

          # configs in browser/config/mozconfigs/mullvad-browser
          with-user-appdir = "mullvad";

          # common configs in mozconfig-linux-x86_64 and similar
          disable-strip = true;
          disable-install-strip = true;
        }
        // lib.optionalAttrs stdenv.targetPlatform.isDarwin {
          # configs in mozconfig-macos
          enable-strip = true;
          enable-nss-mar = true;
          disable-update-agent = true;
        }
      )
      ++ [ "MOZ_TELEMETRY_REPORTING=" ];

    extraNativeBuildInputs = [
      makeWrapper
    ];

    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases" # else alpha/pre-release versions are selected
        "--override-filename=${./package.nix}"
        "--custom-dep=mullvadbrowser-assets"
      ];
    };
    extraPassthru = {
      inherit mullvadbrowser-assets;
    };

    meta = {
      description = "Privacy-focused browser made in collaboration between The Tor Project and Mullvad";
      homepage = "https://mullvad.net/browser";
      mainProgram = "mullvad-browser";
      maintainers = with lib.maintainers; [
        felschr
        panicgh
        sigmasquadron
        mynacol
      ];
      platforms = lib.platforms.unix;
      # since Firefox 60, build on 32-bit platforms fails with "out of memory".
      # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      broken = stdenv.buildPlatform.is32bit;
      maxSilent = 7200;
      license = with lib.licenses; [
        mpl20
        lgpl21Plus
        lgpl3Plus
        gpl3Plus # uBlock Origin, NoScript
        asl20 # Noto fonts
        ofl # Noto CJK fonts
        free
      ];
    };
  }).override
  {
    enableOfficialBranding = true;
    drmSupport = false;
    crashreporterSupport = false;
    geolocationSupport = false; # otherwise we set the provider url to beacondb
    debugBuild = false;
  }
).overrideAttrs
  (_: {
    preFixup =
      let
        libDir =
          if stdenv.isDarwin then
            "Applications/Mullvad Browser.app/Contents/Resources"
          else
            "lib/mullvad-browser";
        executablePath =
          if stdenv.isDarwin then
            "Applications/Mullvad Browser.app/Contents/MacOS/mullvad-browser"
          else
            "bin/mullvad-browser";
      in
      ''
        # copy fonts from the binary package
        rm -rf "$out/${libDir}/fonts"
        cp -r "${mullvadbrowser-assets}/Browser/fonts" "$out/${libDir}/"
        # fixup font.conf file
        substituteInPlace "$out/${libDir}/fonts/fonts.conf" --replace-fail '<dir prefix="cwd">fonts</dir>' "<dir>$out/${libDir}/fonts</dir>"
        # ensure only bundled fonts are used
        wrapProgram "$out/${executablePath}" --set FONTCONFIG_FILE "$out/${libDir}/fonts/fonts.conf"

        # copy extensions from the binary package
        cp -r "${mullvadbrowser-assets}/Browser/distribution" "$out/${libDir}/"
      '';

    strictDeps = true;
    __structuredAttrs = true;
  })
