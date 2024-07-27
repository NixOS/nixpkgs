# Automatic boot assessment with systemd-boot {#sec-automatic-boot-assessment}

## Overview {#sec-automatic-boot-assessment-overview}

Automatic boot assessment (or boot-counting) is a feature of `systemd-boot` that allows for automatically detecting invalid boot entries.
When the feature is active, each boot entry has an associated counter with a user defined number of trials. Whenever `systemd-boot` boots an entry, its counter is decreased by one, ultimately being marked as *bad* if the counter ever reaches zero. However, if an entry is successfully booted, systemd will permanently mark it as *good* and remove the counter altogether. Whenever an entry is marked as *bad*, it is sorted last in the `systemd-boot` menu.
A complete explanation of how that feature works can be found [here](https://systemd.io/AUTOMATIC_BOOT_ASSESSMENT/).

## Enabling the feature {#sec-automatic-boot-assessment-enable}

The feature can be enabled by toogling the [boot.loader.systemd-boot.bootCounting](#opt-boot.loader.systemd-boot.bootCounting.enable) option.

## The boot-complete.target unit {#sec-automatic-boot-assessment-boot-complete-target}

A *successful boot* for an entry is defined in terms of the `boot-complete.target` synchronisation point. It is up to the user to schedule all necessary units for the machine to be considered successfully booted before that synchronisation point.
For example, if you are running `docker` on a machine and you want to be sure that a *good* entry is an entry where docker is started successfully.
A configuration for that NixOS machine could look like that:

```
boot.loader.systemd-boot.bootCounting.enable = true;
services.docker.enable = true;

systemd.services.docker = {
  before = [ "boot-complete.target" ];
  wantedBy = [ "boot-complete.target" ];
  unitConfig.FailureAction = "reboot";
};
```

The systemd service type must be of type `notify` or `oneshot` for systemd to dectect the startup error properly.

## Interaction with specialisations {#sec-automatic-boot-assessment-specialisations}

When the boot-counting feature is enabled, `systemd-boot` will still try the boot entries in the same order as they are displayed in the boot menu. This means that the specialisations of a given generation will be tried directly after that generation, but that behavior is customizable with the [boot.loader.systemd-boot.sortKey](#opt-boot.loader.systemd-boot.sortKey) option.

## Limitations {#sec-automatic-boot-assessment-limitations}

This feature has to be used wisely to not risk any data integrity issues. Rollbacking into past generations can sometimes be dangerous, for example if some of the services may have undefined behaviors in the presence of unrecognized data migrations from future versions of themselves.
