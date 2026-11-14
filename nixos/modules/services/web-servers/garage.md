# Garage {#module-services-garage}

[Garage](https://garagehq.deuxfleurs.fr/)
is an open-source, self-hostable S3 store for geodistributed stores.
The server setup can be automated using
[services.garage](#opt-services.garage.enable).

## General considerations on upgrades {#module-services-garage-upgrade-scenarios}

Garage provides documentation on how to upgrade:
<https://garagehq.deuxfleurs.fr/documentation/operations/upgrading/>

::: {.warning}
Garage has two types of upgrades: minor and major version upgrades.

In all cases, you should read the changelog and ideally test the upgrade on a staging cluster.
:::

Minor versions of the same major version are compatible with each other and NixOS will provide
minor version updates under the same package name.

For major versions you will have to look into the instuctions Garage provides and adjust
[services.garage.package](#opt-services.garage.package).
