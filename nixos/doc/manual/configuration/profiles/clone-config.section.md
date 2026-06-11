# Clone Config {#sec-profile-clone-config}

This profile is used in installer images. It provides an editable
configuration.nix that imports all the modules that were also used when
creating the image in the first place. As a result it allows users to edit
and rebuild the live-system.

On images where the installation media also becomes an installation target,
copying over `configuration.nix` should be disabled by
setting `installer.cloneConfig` to `false`.
For example, this is done in `sd-image-aarch64-installer.nix`.
