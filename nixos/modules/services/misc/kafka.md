# Apache Kafka {#module-services-apache-kafka}

[Apache Kafka](https://kafka.apache.org/) is an open-source distributed event
streaming platform

## Basic Usage {#module-services-apache-kafka-basic-usage}

The Apache Kafka service is configured almost exclusively through its
[settings](#opt-services.apache-kafka.settings) option, with each attribute
corresponding to the [upstream configuration
manual](https://kafka.apache.org/documentation/#configuration) broker settings.

## KRaft {#module-services-apache-kafka-kraft}

Unlike in Zookeeper mode, Kafka in
[KRaft](https://kafka.apache.org/documentation/#kraft) mode requires each log
dir to be "formatted" (which means a cluster-specific a metadata file must
exist in each log dir)

The upstream intention is for users to execute the [storage
tool](https://kafka.apache.org/documentation/#kraft_storage) to achieve this,
but this module contains a few extra options to automate this:

- [](#opt-services.apache-kafka.clusterId)
- [](#opt-services.apache-kafka.formatLogDirs)
- [](#opt-services.apache-kafka.formatLogDirsIgnoreFormatted)

## Migrating to settings {#module-services-apache-kafka-migrating-to-settings}

Migrating a cluster to the new `settings`-based changes requires adapting removed options to the corresponding upstream settings.

This means that the upstream [Broker Configs documentation](https://kafka.apache.org/documentation/#brokerconfigs) should be followed closely.

Note that dotted options in the upstream docs do _not_ correspond to nested Nix attrsets, but instead as quoted top level `settings` attributes, as in `services.apache-kafka.settings."broker.id"`, *NOT* `services.apache-kafka.settings.broker.id`.

Care should be taken, especially when migrating clusters from the old module, to ensure that the same intended configuration is reproduced faithfully via `settings`.

To assist in the comparison, the final config can be inspected by building the config file itself, ie. with: `nix-build <nixpkgs/nixos> -A config.services.apache-kafka.configFiles.serverProperties`.

Notable changes to be aware of include:

- Removal of `services.apache-kafka.extraProperties` and `services.apache-kafka.serverProperties`
  - Translate using arbitrary properties using [](#opt-services.apache-kafka.settings)
  - [Upstream docs](https://kafka.apache.org/documentation.html#brokerconfigs)
  - The intention is for all broker properties to be fully representable via [](#opt-services.apache-kafka.settings).
  - If this is not the case, please do consider raising an issue.
  - Until it can be remedied, you *can* bail out by using [](#opt-services.apache-kafka.configFiles.serverProperties) to the path of a fully rendered properties file.

- Removal of `services.apache-kafka.hostname` and `services.apache-kafka.port`
  - Translate using: `services.apache-kafka.settings.listeners`
  - [Upstream docs](https://kafka.apache.org/documentation.html#brokerconfigs_listeners)

- Removal of `services.apache-kafka.logDirs`
  - Translate using: `services.apache-kafka.settings."log.dirs"`
  - [Upstream docs](https://kafka.apache.org/documentation.html#brokerconfigs_log.dirs)

- Removal of `services.apache-kafka.brokerId`
  - Translate using: `services.apache-kafka.settings."broker.id"`
  - [Upstream docs](https://kafka.apache.org/documentation.html#brokerconfigs_broker.id)

- Removal of `services.apache-kafka.zookeeper`
  - Translate using: `services.apache-kafka.settings."zookeeper.connect"`
  - [Upstream docs](https://kafka.apache.org/documentation.html#brokerconfigs_zookeeper.connect)
