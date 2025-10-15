{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchFromGitLab,
  callPackage,
  config,
  writeShellScript,

  cdrtools, # libvirt
}:
let
  # Our generic constructor to build new providers.
  #
  # Is designed to combine with the terraform.withPlugins implementation.
  mkProvider = lib.makeOverridable (
    {
      owner,
      repo,
      rev,
      spdx ? "UNSET",
      version ? lib.removePrefix "v" rev,
      hash,
      vendorHash,
      deleteVendor ? false,
      proxyVendor ? false,
      mkProviderFetcher ? fetchFromGitHub,
      mkProviderGoModule ? buildGoModule,
      # "https://registry.terraform.io/providers/vancluever/acme"
      homepage ? "",
      # "registry.terraform.io/vancluever/acme"
      provider-source-address ?
        lib.replaceStrings [ "https://registry" ".io/providers" ] [ "registry" ".io" ]
          homepage,
      ...
    }@attrs:
    assert lib.stringLength provider-source-address > 0;
    mkProviderGoModule {
      pname = repo;
      inherit
        vendorHash
        version
        deleteVendor
        proxyVendor
        ;
      subPackages = [ "." ];
      doCheck = false;
      # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
      # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
      env.CGO_ENABLED = 0;
      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=${rev}"
      ];
      src = mkProviderFetcher {
        name = "source-${rev}";
        inherit
          owner
          repo
          rev
          hash
          ;
      };

      meta = {
        inherit homepage;
        license = lib.getLicenseFromSpdxId spdx;
      };

      # Move the provider to libexec
      postInstall = ''
        dir=$out/libexec/terraform-providers/${provider-source-address}/${version}/''${GOOS}_''${GOARCH}
        mkdir -p "$dir"
        mv $out/bin/* "$dir/terraform-provider-$(basename ${provider-source-address})_${version}"
        rmdir $out/bin
      '';

      # Keep the attributes around for later consumption
      passthru = attrs // {
        inherit provider-source-address;
        updateScript = writeShellScript "update" ''
          ./pkgs/applications/networking/cluster/terraform-providers/update-provider "${owner}_${lib.removePrefix "terraform-provider-" repo}"
        '';
      };
    }
  );

  list = lib.importJSON ./providers.json;

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: attrs: mkProvider attrs) list;

  # These are the providers that don't fall in line with the default model
  special-providers = {
    # github api seems to be broken, doesn't just fail to recognize the license, it's ignored entirely.
    checkly_checkly = automated-providers.checkly_checkly.override { spdx = "MIT"; };
    gitlabhq_gitlab = automated-providers.gitlabhq_gitlab.override {
      mkProviderFetcher = fetchFromGitLab;
      owner = "gitlab-org";
    };
    # mkisofs needed to create ISOs holding cloud-init data and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
    dmacvicar_libvirt = automated-providers.dmacvicar_libvirt.overrideAttrs (_: {
      propagatedBuildInputs = [ cdrtools ];
    });
    aminueza_minio = automated-providers.aminueza_minio.override { spdx = "AGPL-3.0-only"; };
  };

  # Put all the providers we not longer support in this list.
  removed-providers =
    let
      archived =
        name: date: throw "the ${name} terraform provider has been archived by upstream on ${date}";
      removed = name: date: throw "the ${name} terraform provider removed from nixpkgs on ${date}";
    in
    lib.optionalAttrs config.allowAliases {
      _assert = archived "_assert" "2025/10";
      azurestack = archived "azurestack" "2025/10";
      googleworkspace = archived "googleworkspace" "2025/10";
      huaweicloudstack = archived "huaweicloudstack" "2025/10";
      metal = archived "metal" "2025/10";
      stackpath = archived "stackpath" "2025/10";
      vra7 = archived "vra7" "2025/10";
    };

  # added 2025-10-12
  renamed-providers = lib.optionalAttrs config.allowAliases {
    onepassword =
      lib.warnOnInstantiate
        "terraform-providers.onepassword has been renamed to terraform-providers.1password_onepassword"
        actualProviders."1password_onepassword";
    thunder = lib.warnOnInstantiate "terraform-providers.thunder has been renamed to terraform-providers.a10networks_thunder" actualProviders.a10networks_thunder;
    netlify = lib.warnOnInstantiate "terraform-providers.netlify has been renamed to terraform-providers.aegirhealth_netlify" actualProviders.aegirhealth_netlify;
    aiven = lib.warnOnInstantiate "terraform-providers.aiven has been renamed to terraform-providers.aiven_aiven" actualProviders.aiven_aiven;
    akamai = lib.warnOnInstantiate "terraform-providers.akamai has been renamed to terraform-providers.akamai_akamai" actualProviders.akamai_akamai;
    alicloud = lib.warnOnInstantiate "terraform-providers.alicloud has been renamed to terraform-providers.aliyun_alicloud" actualProviders.aliyun_alicloud;
    minio = lib.warnOnInstantiate "terraform-providers.minio has been renamed to terraform-providers.aminueza_minio" actualProviders.aminueza_minio;
    auth0 = lib.warnOnInstantiate "terraform-providers.auth0 has been renamed to terraform-providers.auth0_auth0" actualProviders.auth0_auth0;
    aviatrix = lib.warnOnInstantiate "terraform-providers.aviatrix has been renamed to terraform-providers.aviatrixsystems_aviatrix" actualProviders.aviatrixsystems_aviatrix;
    dhall = lib.warnOnInstantiate "terraform-providers.dhall has been renamed to terraform-providers.awakesecurity_dhall" actualProviders.awakesecurity_dhall;
    baiducloud = lib.warnOnInstantiate "terraform-providers.baiducloud has been renamed to terraform-providers.baidubce_baiducloud" actualProviders.baidubce_baiducloud;
    brightbox = lib.warnOnInstantiate "terraform-providers.brightbox has been renamed to terraform-providers.brightbox_brightbox" actualProviders.brightbox_brightbox;
    buildkite = lib.warnOnInstantiate "terraform-providers.buildkite has been renamed to terraform-providers.buildkite_buildkite" actualProviders.buildkite_buildkite;
    pass = lib.warnOnInstantiate "terraform-providers.pass has been renamed to terraform-providers.camptocamp_pass" actualProviders.camptocamp_pass;
    sops = lib.warnOnInstantiate "terraform-providers.sops has been renamed to terraform-providers.carlpett_sops" actualProviders.carlpett_sops;
    checkly = lib.warnOnInstantiate "terraform-providers.checkly has been renamed to terraform-providers.checkly_checkly" actualProviders.checkly_checkly;
    aci = lib.warnOnInstantiate "terraform-providers.aci has been renamed to terraform-providers.ciscodevnet_aci" actualProviders.ciscodevnet_aci;
    ciscoasa = lib.warnOnInstantiate "terraform-providers.ciscoasa has been renamed to terraform-providers.ciscodevnet_ciscoasa" actualProviders.ciscodevnet_ciscoasa;
    age = lib.warnOnInstantiate "terraform-providers.age has been renamed to terraform-providers.clementblaise_age" actualProviders.clementblaise_age;
    cloudamqp = lib.warnOnInstantiate "terraform-providers.cloudamqp has been renamed to terraform-providers.cloudamqp_cloudamqp" actualProviders.cloudamqp_cloudamqp;
    cloudflare = lib.warnOnInstantiate "terraform-providers.cloudflare has been renamed to terraform-providers.cloudflare_cloudflare" actualProviders.cloudflare_cloudflare;
    cloudfoundry = lib.warnOnInstantiate "terraform-providers.cloudfoundry has been renamed to terraform-providers.cloudfoundry-community_cloudfoundry" actualProviders.cloudfoundry-community_cloudfoundry;
    utils = lib.warnOnInstantiate "terraform-providers.utils has been renamed to terraform-providers.cloudposse_utils" actualProviders.cloudposse_utils;
    cloudscale = lib.warnOnInstantiate "terraform-providers.cloudscale has been renamed to terraform-providers.cloudscale-ch_cloudscale" actualProviders.cloudscale-ch_cloudscale;
    constellix = lib.warnOnInstantiate "terraform-providers.constellix has been renamed to terraform-providers.constellix_constellix" actualProviders.constellix_constellix;
    porkbun = lib.warnOnInstantiate "terraform-providers.porkbun has been renamed to terraform-providers.cullenmcdermott_porkbun" actualProviders.cullenmcdermott_porkbun;
    postgresql = lib.warnOnInstantiate "terraform-providers.postgresql has been renamed to terraform-providers.cyrilgdn_postgresql" actualProviders.cyrilgdn_postgresql;
    rabbitmq = lib.warnOnInstantiate "terraform-providers.rabbitmq has been renamed to terraform-providers.cyrilgdn_rabbitmq" actualProviders.cyrilgdn_rabbitmq;
    datadog = lib.warnOnInstantiate "terraform-providers.datadog has been renamed to terraform-providers.datadog_datadog" actualProviders.datadog_datadog;
    nexus = lib.warnOnInstantiate "terraform-providers.nexus has been renamed to terraform-providers.datadrivers_nexus" actualProviders.datadrivers_nexus;
    deno = lib.warnOnInstantiate "terraform-providers.deno has been renamed to terraform-providers.denoland_deno" actualProviders.denoland_deno;
    hydra = lib.warnOnInstantiate "terraform-providers.hydra has been renamed to terraform-providers.determinatesystems_hydra" actualProviders.determinatesystems_hydra;
    digitalocean = lib.warnOnInstantiate "terraform-providers.digitalocean has been renamed to terraform-providers.digitalocean_digitalocean" actualProviders.digitalocean_digitalocean;
    libvirt = lib.warnOnInstantiate "terraform-providers.libvirt has been renamed to terraform-providers.dmacvicar_libvirt" actualProviders.dmacvicar_libvirt;
    dnsimple = lib.warnOnInstantiate "terraform-providers.dnsimple has been renamed to terraform-providers.dnsimple_dnsimple" actualProviders.dnsimple_dnsimple;
    dme = lib.warnOnInstantiate "terraform-providers.dme has been renamed to terraform-providers.dnsmadeeasy_dme" actualProviders.dnsmadeeasy_dme;
    doppler = lib.warnOnInstantiate "terraform-providers.doppler has been renamed to terraform-providers.dopplerhq_doppler" actualProviders.dopplerhq_doppler;
    bitbucket = lib.warnOnInstantiate "terraform-providers.bitbucket has been renamed to terraform-providers.drfaust92_bitbucket" actualProviders.drfaust92_bitbucket;
    equinix = lib.warnOnInstantiate "terraform-providers.equinix has been renamed to terraform-providers.equinix_equinix" actualProviders.equinix_equinix;
    exoscale = lib.warnOnInstantiate "terraform-providers.exoscale has been renamed to terraform-providers.exoscale_exoscale" actualProviders.exoscale_exoscale;
    bigip = lib.warnOnInstantiate "terraform-providers.bigip has been renamed to terraform-providers.f5networks_bigip" actualProviders.f5networks_bigip;
    fastly = lib.warnOnInstantiate "terraform-providers.fastly has been renamed to terraform-providers.fastly_fastly" actualProviders.fastly_fastly;
    flexibleengine = lib.warnOnInstantiate "terraform-providers.flexibleengine has been renamed to terraform-providers.flexibleenginecloud_flexibleengine" actualProviders.flexibleenginecloud_flexibleengine;
    fortios = lib.warnOnInstantiate "terraform-providers.fortios has been renamed to terraform-providers.fortinetdev_fortios" actualProviders.fortinetdev_fortios;
    kubectl = lib.warnOnInstantiate "terraform-providers.kubectl has been renamed to terraform-providers.gavinbunney_kubectl" actualProviders.gavinbunney_kubectl;
    gitlab = lib.warnOnInstantiate "terraform-providers.gitlab has been renamed to terraform-providers.gitlabhq_gitlab" actualProviders.gitlabhq_gitlab;
    gandi = lib.warnOnInstantiate "terraform-providers.gandi has been renamed to terraform-providers.go-gandi_gandi" actualProviders.go-gandi_gandi;
    gitea = lib.warnOnInstantiate "terraform-providers.gitea has been renamed to terraform-providers.go-gitea_gitea" actualProviders.go-gitea_gitea;
    harbor = lib.warnOnInstantiate "terraform-providers.harbor has been renamed to terraform-providers.goharbor_harbor" actualProviders.goharbor_harbor;
    grafana = lib.warnOnInstantiate "terraform-providers.grafana has been renamed to terraform-providers.grafana_grafana" actualProviders.grafana_grafana;
    gridscale = lib.warnOnInstantiate "terraform-providers.gridscale has been renamed to terraform-providers.gridscale_gridscale" actualProviders.gridscale_gridscale;
    archive = lib.warnOnInstantiate "terraform-providers.archive has been renamed to terraform-providers.hashicorp_archive" actualProviders.hashicorp_archive;
    aws = lib.warnOnInstantiate "terraform-providers.aws has been renamed to terraform-providers.hashicorp_aws" actualProviders.hashicorp_aws;
    awscc = lib.warnOnInstantiate "terraform-providers.awscc has been renamed to terraform-providers.hashicorp_awscc" actualProviders.hashicorp_awscc;
    azuread = lib.warnOnInstantiate "terraform-providers.azuread has been renamed to terraform-providers.hashicorp_azuread" actualProviders.hashicorp_azuread;
    azurerm = lib.warnOnInstantiate "terraform-providers.azurerm has been renamed to terraform-providers.hashicorp_azurerm" actualProviders.hashicorp_azurerm;
    cloudinit = lib.warnOnInstantiate "terraform-providers.cloudinit has been renamed to terraform-providers.hashicorp_cloudinit" actualProviders.hashicorp_cloudinit;
    consul = lib.warnOnInstantiate "terraform-providers.consul has been renamed to terraform-providers.hashicorp_consul" actualProviders.hashicorp_consul;
    dns = lib.warnOnInstantiate "terraform-providers.dns has been renamed to terraform-providers.hashicorp_dns" actualProviders.hashicorp_dns;
    external = lib.warnOnInstantiate "terraform-providers.external has been renamed to terraform-providers.hashicorp_external" actualProviders.hashicorp_external;
    google = lib.warnOnInstantiate "terraform-providers.google has been renamed to terraform-providers.hashicorp_google" actualProviders.hashicorp_google;
    google-beta = lib.warnOnInstantiate "terraform-providers.google-beta has been renamed to terraform-providers.hashicorp_google-beta" actualProviders.hashicorp_google-beta;
    helm = lib.warnOnInstantiate "terraform-providers.helm has been renamed to terraform-providers.hashicorp_helm" actualProviders.hashicorp_helm;
    http = lib.warnOnInstantiate "terraform-providers.http has been renamed to terraform-providers.hashicorp_http" actualProviders.hashicorp_http;
    kubernetes = lib.warnOnInstantiate "terraform-providers.kubernetes has been renamed to terraform-providers.hashicorp_kubernetes" actualProviders.hashicorp_kubernetes;
    local = lib.warnOnInstantiate "terraform-providers.local has been renamed to terraform-providers.hashicorp_local" actualProviders.hashicorp_local;
    nomad = lib.warnOnInstantiate "terraform-providers.nomad has been renamed to terraform-providers.hashicorp_nomad" actualProviders.hashicorp_nomad;
    null = lib.warnOnInstantiate "terraform-providers.null has been renamed to terraform-providers.hashicorp_null" actualProviders.hashicorp_null;
    random = lib.warnOnInstantiate "terraform-providers.random has been renamed to terraform-providers.hashicorp_random" actualProviders.hashicorp_random;
    tfe = lib.warnOnInstantiate "terraform-providers.tfe has been renamed to terraform-providers.hashicorp_tfe" actualProviders.hashicorp_tfe;
    time = lib.warnOnInstantiate "terraform-providers.time has been renamed to terraform-providers.hashicorp_time" actualProviders.hashicorp_time;
    tls = lib.warnOnInstantiate "terraform-providers.tls has been renamed to terraform-providers.hashicorp_tls" actualProviders.hashicorp_tls;
    vault = lib.warnOnInstantiate "terraform-providers.vault has been renamed to terraform-providers.hashicorp_vault" actualProviders.hashicorp_vault;
    vsphere = lib.warnOnInstantiate "terraform-providers.vsphere has been renamed to terraform-providers.hashicorp_vsphere" actualProviders.hashicorp_vsphere;
    heroku = lib.warnOnInstantiate "terraform-providers.heroku has been renamed to terraform-providers.heroku_heroku" actualProviders.heroku_heroku;
    hcloud = lib.warnOnInstantiate "terraform-providers.hcloud has been renamed to terraform-providers.hetznercloud_hcloud" actualProviders.hetznercloud_hcloud;
    huaweicloud = lib.warnOnInstantiate "terraform-providers.huaweicloud has been renamed to terraform-providers.huaweicloud_huaweicloud" actualProviders.huaweicloud_huaweicloud;
    ibm = lib.warnOnInstantiate "terraform-providers.ibm has been renamed to terraform-providers.ibm-cloud_ibm" actualProviders.ibm-cloud_ibm;
    icinga2 = lib.warnOnInstantiate "terraform-providers.icinga2 has been renamed to terraform-providers.icinga_icinga2" actualProviders.icinga_icinga2;
    infoblox = lib.warnOnInstantiate "terraform-providers.infoblox has been renamed to terraform-providers.infobloxopen_infoblox" actualProviders.infobloxopen_infoblox;
    github = lib.warnOnInstantiate "terraform-providers.github has been renamed to terraform-providers.integrations_github" actualProviders.integrations_github;
    artifactory = lib.warnOnInstantiate "terraform-providers.artifactory has been renamed to terraform-providers.jfrog_artifactory" actualProviders.jfrog_artifactory;
    project = lib.warnOnInstantiate "terraform-providers.project has been renamed to terraform-providers.jfrog_project" actualProviders.jfrog_project;
    sentry = lib.warnOnInstantiate "terraform-providers.sentry has been renamed to terraform-providers.jianyuan_sentry" actualProviders.jianyuan_sentry;
    openwrt = lib.warnOnInstantiate "terraform-providers.openwrt has been renamed to terraform-providers.joneshf_openwrt" actualProviders.joneshf_openwrt;
    triton = lib.warnOnInstantiate "terraform-providers.triton has been renamed to terraform-providers.joyent_triton" actualProviders.joyent_triton;
    keycloak = lib.warnOnInstantiate "terraform-providers.keycloak has been renamed to terraform-providers.keycloak_keycloak" actualProviders.keycloak_keycloak;
    neon = lib.warnOnInstantiate "terraform-providers.neon has been renamed to terraform-providers.kislerdm_neon" actualProviders.kislerdm_neon;
    docker = lib.warnOnInstantiate "terraform-providers.docker has been renamed to terraform-providers.kreuzwerker_docker" actualProviders.kreuzwerker_docker;
    launchdarkly = lib.warnOnInstantiate "terraform-providers.launchdarkly has been renamed to terraform-providers.launchdarkly_launchdarkly" actualProviders.launchdarkly_launchdarkly;
    linode = lib.warnOnInstantiate "terraform-providers.linode has been renamed to terraform-providers.linode_linode" actualProviders.linode_linode;
    htpasswd = lib.warnOnInstantiate "terraform-providers.htpasswd has been renamed to terraform-providers.loafoe_htpasswd" actualProviders.loafoe_htpasswd;
    ssh = lib.warnOnInstantiate "terraform-providers.ssh has been renamed to terraform-providers.loafoe_ssh" actualProviders.loafoe_ssh;
    incus = lib.warnOnInstantiate "terraform-providers.incus has been renamed to terraform-providers.lxc_incus" actualProviders.lxc_incus;
    dexidp = lib.warnOnInstantiate "terraform-providers.dexidp has been renamed to terraform-providers.marcofranssen_dexidp" actualProviders.marcofranssen_dexidp;
    bitwarden = lib.warnOnInstantiate "terraform-providers.bitwarden has been renamed to terraform-providers.maxlaverse_bitwarden" actualProviders.maxlaverse_bitwarden;
    migadu = lib.warnOnInstantiate "terraform-providers.migadu has been renamed to terraform-providers.metio_migadu" actualProviders.metio_migadu;
    kafka = lib.warnOnInstantiate "terraform-providers.kafka has been renamed to terraform-providers.mongey_kafka" actualProviders.mongey_kafka;
    kafka-connect = lib.warnOnInstantiate "terraform-providers.kafka-connect has been renamed to terraform-providers.mongey_kafka-connect" actualProviders.mongey_kafka-connect;
    mongodbatlas = lib.warnOnInstantiate "terraform-providers.mongodbatlas has been renamed to terraform-providers.mongodb_mongodbatlas" actualProviders.mongodb_mongodbatlas;
    namecheap = lib.warnOnInstantiate "terraform-providers.namecheap has been renamed to terraform-providers.namecheap_namecheap" actualProviders.namecheap_namecheap;
    jetstream = lib.warnOnInstantiate "terraform-providers.jetstream has been renamed to terraform-providers.nats-io_jetstream" actualProviders.nats-io_jetstream;
    ansible = lib.warnOnInstantiate "terraform-providers.ansible has been renamed to terraform-providers.nbering_ansible" actualProviders.nbering_ansible;
    newrelic = lib.warnOnInstantiate "terraform-providers.newrelic has been renamed to terraform-providers.newrelic_newrelic" actualProviders.newrelic_newrelic;
    ns1 = lib.warnOnInstantiate "terraform-providers.ns1 has been renamed to terraform-providers.ns1-terraform_ns1" actualProviders.ns1-terraform_ns1;
    linuxbox = lib.warnOnInstantiate "terraform-providers.linuxbox has been renamed to terraform-providers.numtide_linuxbox" actualProviders.numtide_linuxbox;
    secret = lib.warnOnInstantiate "terraform-providers.secret has been renamed to terraform-providers.numtide_secret" actualProviders.numtide_secret;
    nutanix = lib.warnOnInstantiate "terraform-providers.nutanix has been renamed to terraform-providers.nutanix_nutanix" actualProviders.nutanix_nutanix;
    argocd = lib.warnOnInstantiate "terraform-providers.argocd has been renamed to terraform-providers.oboukili_argocd" actualProviders.oboukili_argocd;
    okta = lib.warnOnInstantiate "terraform-providers.okta has been renamed to terraform-providers.okta_okta" actualProviders.okta_okta;
    oktaasa = lib.warnOnInstantiate "terraform-providers.oktaasa has been renamed to terraform-providers.oktadeveloper_oktaasa" actualProviders.oktadeveloper_oktaasa;
    opennebula = lib.warnOnInstantiate "terraform-providers.opennebula has been renamed to terraform-providers.opennebula_opennebula" actualProviders.opennebula_opennebula;
    openstack = lib.warnOnInstantiate "terraform-providers.openstack has been renamed to terraform-providers.terraform-provider-openstack_openstack" actualProviders.terraform-provider-openstack_openstack;
    opentelekomcloud = lib.warnOnInstantiate "terraform-providers.opentelekomcloud has been renamed to terraform-providers.opentelekomcloud_opentelekomcloud" actualProviders.opentelekomcloud_opentelekomcloud;
    opsgenie = lib.warnOnInstantiate "terraform-providers.opsgenie has been renamed to terraform-providers.opsgenie_opsgenie" actualProviders.opsgenie_opsgenie;
    oci = lib.warnOnInstantiate "terraform-providers.oci has been renamed to terraform-providers.oracle_oci" actualProviders.oracle_oci;
    ovh = lib.warnOnInstantiate "terraform-providers.ovh has been renamed to terraform-providers.ovh_ovh" actualProviders.ovh_ovh;
    slack = lib.warnOnInstantiate "terraform-providers.slack has been renamed to terraform-providers.pablovarela_slack" actualProviders.pablovarela_slack;
    pagerduty = lib.warnOnInstantiate "terraform-providers.pagerduty has been renamed to terraform-providers.pagerduty_pagerduty" actualProviders.pagerduty_pagerduty;
    powerdns = lib.warnOnInstantiate "terraform-providers.powerdns has been renamed to terraform-providers.pan-net_powerdns" actualProviders.pan-net_powerdns;
    elasticsearch = lib.warnOnInstantiate "terraform-providers.elasticsearch has been renamed to terraform-providers.phillbaker_elasticsearch" actualProviders.phillbaker_elasticsearch;
    ct = lib.warnOnInstantiate "terraform-providers.ct has been renamed to terraform-providers.poseidon_ct" actualProviders.poseidon_ct;
    matchbox = lib.warnOnInstantiate "terraform-providers.matchbox has been renamed to terraform-providers.poseidon_matchbox" actualProviders.poseidon_matchbox;
    rancher2 = lib.warnOnInstantiate "terraform-providers.rancher2 has been renamed to terraform-providers.rancher_rancher2" actualProviders.rancher_rancher2;
    rootly = lib.warnOnInstantiate "terraform-providers.rootly has been renamed to terraform-providers.rootlyhq_rootly" actualProviders.rootlyhq_rootly;
    rundeck = lib.warnOnInstantiate "terraform-providers.rundeck has been renamed to terraform-providers.rundeck_rundeck" actualProviders.rundeck_rundeck;
    sakuracloud = lib.warnOnInstantiate "terraform-providers.sakuracloud has been renamed to terraform-providers.sacloud_sakuracloud" actualProviders.sacloud_sakuracloud;
    btp = lib.warnOnInstantiate "terraform-providers.btp has been renamed to terraform-providers.sap_btp" actualProviders.sap_btp;
    ccloud = lib.warnOnInstantiate "terraform-providers.ccloud has been renamed to terraform-providers.sapcc_ccloud" actualProviders.sapcc_ccloud;
    scaleway = lib.warnOnInstantiate "terraform-providers.scaleway has been renamed to terraform-providers.scaleway_scaleway" actualProviders.scaleway_scaleway;
    shell = lib.warnOnInstantiate "terraform-providers.shell has been renamed to terraform-providers.scottwinkler_shell" actualProviders.scottwinkler_shell;
    selectel = lib.warnOnInstantiate "terraform-providers.selectel has been renamed to terraform-providers.selectel_selectel" actualProviders.selectel_selectel;
    talos = lib.warnOnInstantiate "terraform-providers.talos has been renamed to terraform-providers.siderolabs_talos" actualProviders.siderolabs_talos;
    skytap = lib.warnOnInstantiate "terraform-providers.skytap has been renamed to terraform-providers.skytap_skytap" actualProviders.skytap_skytap;
    snowflake = lib.warnOnInstantiate "terraform-providers.snowflake has been renamed to terraform-providers.snowflake-labs_snowflake" actualProviders.snowflake-labs_snowflake;
    spacelift = lib.warnOnInstantiate "terraform-providers.spacelift has been renamed to terraform-providers.spacelift-io_spacelift" actualProviders.spacelift-io_spacelift;
    signalfx = lib.warnOnInstantiate "terraform-providers.signalfx has been renamed to terraform-providers.splunk-terraform_signalfx" actualProviders.splunk-terraform_signalfx;
    spotinst = lib.warnOnInstantiate "terraform-providers.spotinst has been renamed to terraform-providers.spotinst_spotinst" actualProviders.spotinst_spotinst;
    statuscake = lib.warnOnInstantiate "terraform-providers.statuscake has been renamed to terraform-providers.statuscakedev_statuscake" actualProviders.statuscakedev_statuscake;
    sumologic = lib.warnOnInstantiate "terraform-providers.sumologic has been renamed to terraform-providers.sumologic_sumologic" actualProviders.sumologic_sumologic;
    sysdig = lib.warnOnInstantiate "terraform-providers.sysdig has been renamed to terraform-providers.sysdiglabs_sysdig" actualProviders.sysdiglabs_sysdig;
    tailscale = lib.warnOnInstantiate "terraform-providers.tailscale has been renamed to terraform-providers.tailscale_tailscale" actualProviders.tailscale_tailscale;
    proxmox = lib.warnOnInstantiate "terraform-providers.proxmox has been renamed to terraform-providers.telmate_proxmox" actualProviders.telmate_proxmox;
    temporalcloud = lib.warnOnInstantiate "terraform-providers.temporalcloud has been renamed to terraform-providers.temporalio_temporalcloud" actualProviders.temporalio_temporalcloud;
    tencentcloud = lib.warnOnInstantiate "terraform-providers.tencentcloud has been renamed to terraform-providers.tencentcloudstack_tencentcloud" actualProviders.tencentcloudstack_tencentcloud;
    remote = lib.warnOnInstantiate "terraform-providers.remote has been renamed to terraform-providers.tenstad_remote" actualProviders.tenstad_remote;
    virtualbox = lib.warnOnInstantiate "terraform-providers.virtualbox has been renamed to terraform-providers.terra-farm_virtualbox" actualProviders.terra-farm_virtualbox;
    lxd = lib.warnOnInstantiate "terraform-providers.lxd has been renamed to terraform-providers.terraform-lxd_lxd" actualProviders.terraform-lxd_lxd;
    routeros = lib.warnOnInstantiate "terraform-providers.routeros has been renamed to terraform-providers.terraform-routeros_routeros" actualProviders.terraform-routeros_routeros;
    hetznerdns = lib.warnOnInstantiate "terraform-providers.hetznerdns has been renamed to terraform-providers.timohirt_hetznerdns" actualProviders.timohirt_hetznerdns;
    pocketid = lib.warnOnInstantiate "terraform-providers.pocketid has been renamed to terraform-providers.trozz_pocketid" actualProviders.trozz_pocketid;
    turbot = lib.warnOnInstantiate "terraform-providers.turbot has been renamed to terraform-providers.turbot_turbot" actualProviders.turbot_turbot;
    unifi = lib.warnOnInstantiate "terraform-providers.unifi has been renamed to terraform-providers.ubiquiti-community_unifi" actualProviders.ubiquiti-community_unifi;
    ucloud = lib.warnOnInstantiate "terraform-providers.ucloud has been renamed to terraform-providers.ucloud_ucloud" actualProviders.ucloud_ucloud;
    acme = lib.warnOnInstantiate "terraform-providers.acme has been renamed to terraform-providers.vancluever_acme" actualProviders.vancluever_acme;
    venafi = lib.warnOnInstantiate "terraform-providers.venafi has been renamed to terraform-providers.venafi_venafi" actualProviders.venafi_venafi;
    vinyldns = lib.warnOnInstantiate "terraform-providers.vinyldns has been renamed to terraform-providers.vinyldns_vinyldns" actualProviders.vinyldns_vinyldns;
    avi = lib.warnOnInstantiate "terraform-providers.avi has been renamed to terraform-providers.vmware_avi" actualProviders.vmware_avi;
    vcd = lib.warnOnInstantiate "terraform-providers.vcd has been renamed to terraform-providers.vmware_vcd" actualProviders.vmware_vcd;
    wavefront = lib.warnOnInstantiate "terraform-providers.wavefront has been renamed to terraform-providers.vmware_wavefront" actualProviders.vmware_wavefront;
    vpsadmin = lib.warnOnInstantiate "terraform-providers.vpsadmin has been renamed to terraform-providers.vpsfreecz_vpsadmin" actualProviders.vpsfreecz_vpsadmin;
    vultr = lib.warnOnInstantiate "terraform-providers.vultr has been renamed to terraform-providers.vultr_vultr" actualProviders.vultr_vultr;
    mailgun = lib.warnOnInstantiate "terraform-providers.mailgun has been renamed to terraform-providers.wgebis_mailgun" actualProviders.wgebis_mailgun;
    yandex = lib.warnOnInstantiate "terraform-providers.yandex has been renamed to terraform-providers.yandex-cloud_yandex" actualProviders.yandex-cloud_yandex;
  };

  # excluding aliases, used by terraform-full
  actualProviders = automated-providers // special-providers;
in
actualProviders // removed-providers // renamed-providers // { inherit actualProviders mkProvider; }
