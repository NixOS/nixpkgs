# Firefox {#sec-firefox}

## Build wrapped Firefox with extensions and policies {#build-wrapped-firefox-with-extensions-and-policies}

The `wrapFirefox` function allows to pass policies, preferences and extension that are available to Firefox. With the help of `fetchFirefoxAddon` this allows build a Firefox version that already comes with addons pre-installed:

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
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };
}
```

If `nixExtensions != null` then all manually installed addons will be uninstalled from your browser profile.
To view available enterprise policies visit [enterprise policies](https://github.com/mozilla/policy-templates#enterprisepoliciesenabled)
or type into the Firefox url bar: `about:policies#documentation`.
Nix installed addons do not have a valid signature, which is why signature verification is disabled. This does not compromise security because downloaded addons are checksumed and manual addons can't be installed. Also make sure that the `name` field of fetchFirefoxAddon is unique. If you remove an addon from the nixExtensions array, rebuild and start Firefox the removed addon will be completly removed with all of its settings.

## Troubleshooting {#sec-firefox-troubleshooting}
If addons are marked as broken or the signature is invalid, make sure you have Firefox ESR installed. Normal Firefox does not provide the ability anymore to disable signature verification for addons thus nix addons get disabled by the normal Firefox binary.

If addons do not appear installed although they have been defined in your nix configuration file reset the local addon state of your Firefox profile by clicking `help -> restart with addons disabled -> restart -> refresh firefox`. This can happen if you switch from manual addon mode to nix addon mode and then back to manual mode and then again to nix addon mode.

