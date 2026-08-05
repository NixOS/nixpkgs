# Microsoft OneDrive {#module-services-onedrive}

Microsoft Onedrive is a popular cloud file-hosting service, used by 85%
of Fortune 500 companies. NixOS uses a popular OneDrive client for Linux
maintained by github user abraunegg. The Linux client is excellent and
allows customization of which files or paths to download, not much
unlike the default Windows OneDrive client by Microsoft itself. The
client allows syncing with multiple onedrive accounts at the same time,
of any type- OneDrive personal, OneDrive business, Office365 and
Sharepoint libraries, without any additional charge.

For more information, guides and documentation, see <https://abraunegg.github.io/>.

To enable OneDrive support, add the following to your
`configuration.nix`: {option}`services.onedrive.enable` = true;

This installs the `onedrive` package and a service `onedriveLauncher`
which will instantiate a `onedrive` service for all your OneDrive
accounts. Follow the steps in documentation of the onedrive client to
setup your accounts. To use the service with multiple accounts, create a
file named `onedrive-launcher` in `~/.config` and add the filename of
the config directory, relative to `~/.config`. For example, if you have
two OneDrive accounts with configs in `~/.config/onedrive_bob_work` and
`~/.config/onedrive_bob_personal`, add the following lines:

```
onedrive_bob_work
# Not in use:
# onedrive_bob_office365
onedrive_bob_personal
```

No such file needs to be created if you are using only a single OneDrive
account with config in the default location `~/.config/onedrive`, in the
absence of `~/.config/onedrive-launcher`, only a single service is
instantiated, with default config path.

If you wish to use a custom OneDrive package, say from another channel,
add the following line: {option}`services.onedrive.package` = pkgs.unstable.onedrive;
