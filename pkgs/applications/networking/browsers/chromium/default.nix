{ newScope, stdenv, makeWrapper, makeDesktopItem, writeScript

# package customization
, channel ? "stable"
, enableSELinux ? false
, enableNaCl ? false
, enableHotwording ? false
, gnomeSupport ? false
, gnomeKeyringSupport ? false
, proprietaryCodecs ? true
, enablePepperFlash ? false
, enableWideVine ? false
, cupsSupport ? true
, pulseSupport ? false
, hiDPISupport ? false
}:

let
  callPackage = newScope chromium;

  chromium = {
    upstream-info = (callPackage ./update.nix {}).getChannel channel;

    mkChromiumDerivation = callPackage ./common.nix {
      inherit enableSELinux enableNaCl enableHotwording gnomeSupport
              gnomeKeyringSupport proprietaryCodecs cupsSupport pulseSupport
              hiDPISupport;
    };

    browser = callPackage ./browser.nix { inherit channel; };

    plugins = callPackage ./plugins.nix {
      inherit enablePepperFlash enableWideVine;
    };
  };

  desktopItem = makeDesktopItem {
    name = "chromium";
    exec = "chromium %U";
    icon = "chromium";
    comment = "An open source web browser from Google";
    desktopName = "Chromium";
    genericName = "Web browser";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/mailto"
      "x-scheme-handler/webcal"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
    categories = "Network;WebBrowser";
    extraEntries = ''
      StartupWMClass=chromium-browser
    '';
  };

  suffix = if channel != "stable" then "-" + channel else "";

  sandboxExecutableName = chromium.browser.passthru.sandboxExecutableName;

in stdenv.mkDerivation {
  name = "chromium${suffix}-${chromium.browser.version}";

  buildInputs = [ makeWrapper ];

  outputs = ["out" "sandbox"];

  buildCommand = let
    browserBinary = "${chromium.browser}/libexec/chromium/chromium";
    getWrapperFlags = plugin: "$(< \"${plugin}/nix-support/wrapper-flags\")";
    sandboxExecutableSourcePath = "${chromium.browser}/libexec/chromium/chrome-sandbox";
    launchScript = writeScript "chromium" ''
      #! ${stdenv.shell}

      if [ -x "/var/setuid-wrappers/${sandboxExecutableName}" ]
      then
        export CHROME_DEVEL_SANDBOX="/var/setuid-wrappers/${sandboxExecutableName}"
      else
        export CHROME_DEVEL_SANDBOX="@sandbox@/bin/${sandboxExecutableName}"
      fi

      # libredirect causes chromium to deadlock on startup
      export LD_PRELOAD="$(echo -n "$LD_PRELOAD" | tr ':' '\n' | grep -v /lib/libredirect\\.so$ | tr '\n' ':')"

      exec @out@/bin/.chromium-wrapped "''${extraFlagsArray[@]}" "$@"
    '';
  in with stdenv.lib; ''
    mkdir -p "$out/bin" "$out/share/applications"

    ln -s "${chromium.browser}/share" "$out/share"
    eval makeWrapper "${browserBinary}" "$out/bin/.chromium-wrapped" \
      ${concatMapStringsSep " " getWrapperFlags chromium.plugins.enabled}

    cp -v "${launchScript}" "$out/bin/chromium"
    substituteInPlace $out/bin/chromium --replace @out@ $out --replace @sandbox@ $sandbox
    chmod 755 "$out/bin/chromium"

    mkdir -p "$sandbox/bin"
    [ -x "${sandboxExecutableSourcePath}" ] || exit 1
    ln -sv "${sandboxExecutableSourcePath}" "$sandbox/bin/${sandboxExecutableName}"

    ln -s "$out/bin/chromium" "$out/bin/chromium-browser"
    ln -s "${chromium.browser}/share/icons" "$out/share/icons"
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  inherit (chromium.browser) meta packageName;

  passthru = {
    inherit (chromium) upstream-info;
    mkDerivation = chromium.mkChromiumDerivation;
    inherit sandboxExecutableName;
  };
}
