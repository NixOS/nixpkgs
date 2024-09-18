# RKE2 Version

RKE2, Kubernetes, and other clustered software has the property of not being able to update atomically. Most software in nixpkgs, like for example bash, can be updated as part of a `nixos-rebuild switch` without having to worry about the old and the new bash interacting in some way.

> [!NOTE]
> Upgrade the server nodes first, one at a time. Once all servers have been upgraded, you may then upgrade agent nodes.

## Release Channels

RKE2 has there own release channels, which are: `stable`, `latest` and `testing`.

The `stable` channel is the default channel and is recommended for production use. The `latest` channel is the latest stable release. The `testing` channel is the latest release, including pre-releases.

| Channel   | Description                                                                                                                                                                                    |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `stable`  | **(Default)** Stable is recommended for production environments. These releases have been through a period of community hardening, and are compatible with the most recent release of Rancher. |
| `latest`  | Latest is recommended for trying out the latest features. These releases have not yet been through a period of community hardening, and may not be compatible with Rancher.                    |
| `testing` | The most recent release, including pre-releases.                                                                                                                                               |

Learn more about the [RKE2 release channels](https://docs.rke2.io/upgrade/manual_upgrade).

For an exhaustive and up-to-date list of channels, you can visit the [rke2 channel service API](https://update.rke2.io/v1-release/channels). For more technical details on how channels work, you can see the [channelserver project](https://github.com/rancher/channelserver).

> [!TIP]
> When attempting to upgrade to a new version of RKE2, the [Kubernetes version skew policy](https://kubernetes.io/docs/setup/release/version-skew-policy) applies. Ensure that your plan does not skip intermediate minor versions when upgrading. Nothing in the upgrade process will protect against unsupported changes to the Kubernetes version.
