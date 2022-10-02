# Firefox {#sec-firefox}

## Build wrapped Firefox with extensions and policies {#build-wrapped-firefox-with-extensions-and-policies}

The `wrapFirefox` function allows to pass policies, preferences and extensions that are available to Firefox. With the help of `fetchFirefoxAddon` this allows to build a Firefox version that already comes with add-ons pre-installed:

```nix
{
  # Nix firefox addons only work with the firefox-esr package.
  myFirefox = wrapFirefox firefox-esr-unwrapped {
    nixExtensions = [
      (fetchFirefoxAddon {
        name = "ublock"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
        sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
      })
    ];

    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      SecurityDevices = {
        # Use a proxy module rather than `nixpkgs.config.firefox.smartcardSupport = true`
        "PKCS#11 Proxy Module" = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
      };
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };
}
```

If `nixExtensions != null`, then all manually installed add-ons will be uninstalled from your browser profile.
To view available enterprise policies, visit [enterprise policies](https://github.com/mozilla/policy-templates#enterprisepoliciesenabled)
or type into the Firefox URL bar: `about:policies#documentation`.
Nix installed add-ons do not have a valid signature, which is why signature verification is disabled. This does not compromise security because downloaded add-ons are checksummed and manual add-ons can't be installed. Also, make sure that the `name` field of `fetchFirefoxAddon` is unique. If you remove an add-on from the `nixExtensions` array, rebuild and start Firefox: the removed add-on will be completely removed with all of its settings.

## Troubleshooting {#sec-firefox-troubleshooting}
If add-ons are marked as broken or the signature is invalid, make sure you have Firefox ESR installed. Normal Firefox does not provide the ability anymore to disable signature verification for add-ons thus nix add-ons get disabled by the normal Firefox binary.

If add-ons do not appear installed despite being defined in your nix configuration file, reset the local add-on state of your Firefox profile by clicking `Help -> More Troubleshooting Information -> Refresh Firefox`. This can happen if you switch from manual add-on mode to nix add-on mode and then back to manual mode and then again to nix add-on mode.
