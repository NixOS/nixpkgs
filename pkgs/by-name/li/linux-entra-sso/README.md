# Linux Entra SSO

`linux-entra-sso` provides a native messaging host that connects browser extensions
to a local Microsoft Identity Broker over the user's D-Bus session. It requires a
working broker and an enrolled account; installing this package does not enroll
the device in Intune.

On NixOS, enable [`services.intune.enable`](https://search.nixos.org/options?channel=unstable&show=services.intune.enable&query=services.intune)
to install the broker and Intune Portal. The current Intune module installs the
units but does not enable the daemon socket or agent timer. Enable them with:

```nix
{
  systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
  systemd.user.timers.intune-agent.wantedBy = [ "graphical-session.target" ];
}
```

The desktop session also needs a Secret Service keyring. NixOS enables GNOME
Keyring by default with GNOME; other desktop setups may need explicit
configuration. Complete enrollment and sign in through `intune-portal` before
setting up the browser extension. These prerequisites are separate from the
SSO host package.

The browser extension must be installed separately. Use the signed Firefox
extension from the [upstream releases](https://github.com/siemens/linux-entra-sso/releases)
or the [Chrome Web Store extension](https://chromewebstore.google.com/detail/linux-entrasso/jlnfnnolkbjieggibinobhkjdfbpcohn).

## Firefox on NixOS

Register the native messaging host with the NixOS Firefox module:

```nix
{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.linux-entra-sso ];
  };
}
```

## Chrome, Chromium, Brave, and Vivaldi on NixOS

Install the Chrome Web Store extension and register the native host for each
browser you use:

```nix
{ pkgs, ... }:
{
  environment.etc."opt/chrome/native-messaging-hosts/linux_entra_sso.json".source =
    "${pkgs.linux-entra-sso}/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json";

  environment.etc."chromium/native-messaging-hosts/linux_entra_sso.json".source =
    "${pkgs.linux-entra-sso}/etc/chromium/native-messaging-hosts/linux_entra_sso.json";

  environment.etc."opt/brave/native-messaging-hosts/linux_entra_sso.json".source =
    "${pkgs.linux-entra-sso}/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json";

  environment.etc."opt/vivaldi/native-messaging-hosts/linux_entra_sso.json".source =
    "${pkgs.linux-entra-sso}/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json";
}
```

Installing the package through `environment.systemPackages` alone does not
register these manifests. These paths follow the NixOS Browserpass module and
apply to native browser packages, not Flatpak installations.

## Verification

Restart the browser, select your account in the extension, and try a fresh work
sign-in. Grant access to `https://login.microsoftonline.com` if prompted.

To check broker connectivity, run as the enrolled user in their desktop session:

```ShellSession
$ nix shell nixpkgs#linux-entra-sso --command linux-entra-sso --interactive getAccounts
```

See the [upstream documentation](https://github.com/siemens/linux-entra-sso) for troubleshooting.
