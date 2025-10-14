{
  system,
  pkgs,

  # Projects the test configuration into a the desired value; usually
  # the test runner: `config: config.test`.
  callTest,

}:
# The return value of this function will be an attrset with arbitrary depth and
# the `anything` returned by callTest at its test leaves.
# The tests not supported by `system` will be replaced with `{}`, so that
# `passthru.tests` can contain links to those without breaking on architectures
# where said tests are unsupported.
# Example callTest that just extracts the derivation from the test:
#   callTest = t: t.test;

with pkgs.lib;

let
  discoverTests =
    val:
    if isAttrs val then
      if hasAttr "test" val then
        callTest val
      else
        mapAttrs (n: s: if n == "passthru" then s else discoverTests s) val
    else if isFunction val then
      # Tests based on make-test-python.nix will return the second lambda
      # in that file, which are then forwarded to the test definition
      # following the `import make-test-python.nix` expression
      # (if it is a function).
      discoverTests (val {
        inherit system pkgs;
      })
    else
      val;

  /**
    Evaluate a test and return a derivation that runs the test as its builder.

    This function is deprecated in favor of runTest and runTestOn, which works
    by passing a module instead of a specific set of arguments.
    Benefits of runTest and runTestOn:
    - Define values for any test option
    - Use imports to compose tests
    - Access the module arguments like hostPkgs and config.node.pkgs
    - Portable to other VM hosts, specifically Darwin
    - Faster evaluation, using a single `pkgs` instance

    Changes required to migrate to runTest:
    - Remove any `import ../make-test-python.nix` or similar calls, leaving only
      the callback function.
    - Convert the function header to make it a module.
      Packages can be taken from the following. For VM host portability, use
      - `config.node.pkgs.<name>` or `config.nodes.foo.nixpkgs.pkgs.<name>` to refer
        to the Nixpkgs used on the VM guest(s).
      - `hostPkgs.<name>` when invoking commands on the VM host (e.g. in Python
        `os.system("foo")`)
    - Since the runTest argument is a module instead of a function, arguments
      must be passed as option definitions.
      You may declare explicit `options` for the test parameter(s), or use the
      less explicit `_module.args.<name>` to pass arguments to the module.

      Example call with arguments:

          runTest {
            imports = [ ./test.nix ];
            _module.args.getPackage = pkgs: pkgs.foo_1_2;
          }

    - If your test requires any definitions in `nixpkgs.*` options, set
      `node.pkgsReadOnly = false` in the test configuration.
  */
  handleTest = path: args: discoverTests (import path ({ inherit system pkgs; } // args));

  /**
    See handleTest
  */
  handleTestOn =
    systems: path: args:
    if elem system systems then handleTest path args else { };

  nixosLib = import ../lib {
    # Experimental features need testing too, but there's no point in warning
    # about it, so we enable the feature flag.
    featureFlags.minimalModules = { };
  };
  evalMinimalConfig = module: nixosLib.evalModules { modules = [ module ]; };

  inherit
    (rec {
      doRunTest =
        arg:
        ((import ../lib/testing-python.nix { inherit system pkgs; }).evalTest {
          imports = [
            arg
            readOnlyPkgs
          ];
        }).config.result;
      findTests =
        tree:
        if tree ? recurseForDerivations && tree.recurseForDerivations then
          mapAttrs (k: findTests) (builtins.removeAttrs tree [ "recurseForDerivations" ])
        else
          callTest tree;

      runTest =
        arg:
        let
          r = doRunTest arg;
        in
        findTests r;
      runTestOn = systems: arg: if elem system systems then runTest arg else { };
    })
    /**
      See https://nixos.org/manual/nixos/unstable/#sec-calling-nixos-tests
    */
    runTest
    /**
      See https://nixos.org/manual/nixos/unstable/#sec-calling-nixos-tests
    */
    runTestOn
    ;

  # Using a single instance of nixpkgs makes test evaluation faster.
  # To make sure we don't accidentally depend on a modified pkgs, we make the
  # related options read-only. We need to test the right configuration.
  #
  # If your service depends on a nixpkgs setting, first try to avoid that, but
  # otherwise, you can remove the readOnlyPkgs import and test your service as
  # usual.
  readOnlyPkgs =
    # TODO: We currently accept this for nixosTests, so that the `pkgs` argument
    #       is consistent with `pkgs` in `pkgs.nixosTests`. Can we reinitialize
    #       it with `allowAliases = false`?
    # warnIf pkgs.config.allowAliases "nixosTests: pkgs includes aliases."
    {
      _file = "${__curPos.file} readOnlyPkgs";
      _class = "nixosTest";
      node.pkgs = pkgs.pkgsLinux;
    };

in
{

  # Testing the test driver
  nixos-test-driver = {
    extra-python-packages = handleTest ./nixos-test-driver/extra-python-packages.nix { };
    lib-extend = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./nixos-test-driver/lib-extend.nix { };
    node-name = runTest ./nixos-test-driver/node-name.nix;
    busybox = runTest ./nixos-test-driver/busybox.nix;
    driver-timeout =
      pkgs.runCommand "ensure-timeout-induced-failure"
        {
          failed = pkgs.testers.testBuildFailure (
            (runTest ./nixos-test-driver/timeout.nix).config.rawTestDerivation
          );
        }
        ''
          grep -F "timeout reached; test terminating" $failed/testBuildFailure.log
          # The program will always be terminated by SIGTERM (143) if it waits for the deadline thread.
          [[ 143 = $(cat $failed/testBuildFailure.exit) ]]
          touch $out
        '';
  };

  # NixOS vm tests and non-vm unit tests

  # keep-sorted start case=no numeric=no block=yes
  _3proxy = runTest ./3proxy.nix;
  aaaaxy = runTest ./aaaaxy.nix;
  acme = import ./acme/default.nix { inherit runTest; };
  acme-dns = runTest ./acme-dns.nix;
  activation = pkgs.callPackage ../modules/system/activation/test.nix { };
  activation-etc-overlay-immutable = runTest ./activation/etc-overlay-immutable.nix;
  activation-etc-overlay-mutable = runTest ./activation/etc-overlay-mutable.nix;
  activation-lib = pkgs.callPackage ../modules/system/activation/lib/test.nix { };
  activation-nix-channel = runTest ./activation/nix-channel.nix;
  activation-perlless = runTest ./activation/perlless.nix;
  activation-var = runTest ./activation/var.nix;
  actual = runTest ./actual.nix;
  adguardhome = runTest ./adguardhome.nix;
  aesmd = runTestOn [ "x86_64-linux" ] ./aesmd.nix;
  agate = runTest ./web-servers/agate.nix;
  agda = runTest ./agda.nix;
  age-plugin-tpm-decrypt = runTest ./age-plugin-tpm-decrypt.nix;
  agnos = discoverTests (import ./agnos.nix);
  agorakit = runTest ./web-apps/agorakit.nix;
  airsonic = runTest ./airsonic.nix;
  akkoma = runTestOn [ "x86_64-linux" "aarch64-linux" ] {
    imports = [ ./akkoma.nix ];
    _module.args.confined = false;
  };
  akkoma-confined = runTestOn [ "x86_64-linux" "aarch64-linux" ] {
    imports = [ ./akkoma.nix ];
    _module.args.confined = true;
  };
  alice-lg = runTest ./alice-lg.nix;
  alloy = runTest ./alloy.nix;
  allTerminfo = runTest ./all-terminfo.nix;
  alps = runTest ./alps.nix;
  amazon-cloudwatch-agent = runTest ./amazon-cloudwatch-agent.nix;
  amazon-init-shell = runTest ./amazon-init-shell.nix;
  amazon-ssm-agent = runTest ./amazon-ssm-agent.nix;
  amd-sev = runTest ./amd-sev.nix;
  angie-api = runTest ./angie-api.nix;
  anki-sync-server = runTest ./anki-sync-server.nix;
  anubis = runTest ./anubis.nix;
  anuko-time-tracker = runTest ./anuko-time-tracker.nix;
  apcupsd = runTest ./apcupsd.nix;
  apfs = runTest ./apfs.nix;
  apparmor = runTest ./apparmor;
  appliance-repart-image = runTest ./appliance-repart-image.nix;
  appliance-repart-image-verity-store = runTest ./appliance-repart-image-verity-store.nix;
  archi = runTest ./archi.nix;
  aria2 = runTest ./aria2.nix;
  armagetronad = runTest ./armagetronad.nix;
  artalk = runTest ./artalk.nix;
  atd = runTest ./atd.nix;
  atop = import ./atop.nix { inherit pkgs runTest; };
  atticd = runTest ./atticd.nix;
  atuin = runTest ./atuin.nix;
  audiobookshelf = runTest ./audiobookshelf.nix;
  auth-mysql = runTest ./auth-mysql.nix;
  authelia = runTest ./authelia.nix;
  auto-cpufreq = runTest ./auto-cpufreq.nix;
  autobrr = runTest ./autobrr.nix;
  avahi = runTest {
    imports = [ ./avahi.nix ];
    _module.args.networkd = false;
  };
  avahi-with-resolved = runTest {
    imports = [ ./avahi.nix ];
    _module.args.networkd = true;
  };
  ax25 = handleTest ./ax25.nix { };
  ayatana-indicators = runTest ./ayatana-indicators.nix;
  babeld = runTest ./babeld.nix;
  bazarr = runTest ./bazarr.nix;
  bcachefs = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./bcachefs.nix;
  beanstalkd = runTest ./beanstalkd.nix;
  bees = runTest ./bees.nix;
  benchexec = handleTest ./benchexec.nix { };
  binary-cache = runTest {
    imports = [ ./binary-cache.nix ];
    _module.args.compression = "zstd";
  };
  binary-cache-no-compression = runTest {
    imports = [ ./binary-cache.nix ];
    _module.args.compression = "none";
  };
  binary-cache-xz = runTest {
    imports = [ ./binary-cache.nix ];
    _module.args.compression = "xz";
  };
  bind = runTest ./bind.nix;
  bird = handleTest ./bird.nix { };
  birdwatcher = handleTest ./birdwatcher.nix { };
  bitbox-bridge = runTest ./bitbox-bridge.nix;
  bitcoind = handleTest ./bitcoind.nix { };
  bittorrent = handleTest ./bittorrent.nix { };
  blockbook-frontend = handleTest ./blockbook-frontend.nix { };
  blocky = handleTest ./blocky.nix { };
  boot = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./boot.nix { };
  boot-stage1 = handleTest ./boot-stage1.nix { };
  boot-stage2 = handleTest ./boot-stage2.nix { };
  bootspec = handleTestOn [ "x86_64-linux" ] ./bootspec.nix { };
  borgbackup = handleTest ./borgbackup.nix { };
  borgmatic = handleTest ./borgmatic.nix { };
  botamusique = runTest ./botamusique.nix;
  bpf = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./bpf.nix { };
  bpftune = handleTest ./bpftune.nix { };
  breitbandmessung = handleTest ./breitbandmessung.nix { };
  brscan5 = handleTest ./brscan5.nix { };
  btrbk = handleTest ./btrbk.nix { };
  btrbk-doas = handleTest ./btrbk-doas.nix { };
  btrbk-no-timer = handleTest ./btrbk-no-timer.nix { };
  btrbk-section-order = handleTest ./btrbk-section-order.nix { };
  budgie = handleTest ./budgie.nix { };
  buildbot = runTest ./buildbot.nix;
  buildkite-agents = handleTest ./buildkite-agents.nix { };
  c2fmzq = handleTest ./c2fmzq.nix { };
  caddy = runTest ./caddy.nix;
  cadvisor = handleTestOn [ "x86_64-linux" ] ./cadvisor.nix { };
  cage = handleTest ./cage.nix { };
  cagebreak = handleTest ./cagebreak.nix { };
  calibre-server = import ./calibre-server.nix { inherit pkgs runTest; };
  calibre-web = runTest ./calibre-web.nix;
  canaille = handleTest ./canaille.nix { };
  cassandra_4 = handleTest ./cassandra.nix { testPackage = pkgs.cassandra_4; };
  castopod = handleTest ./castopod.nix { };
  centrifugo = runTest ./centrifugo.nix;
  ceph-multi-node = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./ceph-multi-node.nix { };
  ceph-single-node = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./ceph-single-node.nix { };
  ceph-single-node-bluestore = handleTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./ceph-single-node-bluestore.nix { };
  ceph-single-node-bluestore-dmcrypt = handleTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./ceph-single-node-bluestore-dmcrypt.nix { };
  certmgr = handleTest ./certmgr.nix { };
  cfssl = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./cfssl.nix { };
  cgit = runTest ./cgit.nix;
  charliecloud = handleTest ./charliecloud.nix { };
  chhoto-url = runTest ./chhoto-url.nix;
  chromadb = runTest ./chromadb.nix;
  chromium = (handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chromium.nix { }).stable or { };
  chrony = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony.nix { };
  chrony-ptp = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony-ptp.nix { };
  cinnamon = handleTest ./cinnamon.nix { };
  cinnamon-wayland = handleTest ./cinnamon-wayland.nix { };
  cjdns = handleTest ./cjdns.nix { };
  clatd = runTest ./clatd.nix;
  clickhouse = handleTest ./clickhouse.nix { };
  cloud-init = handleTest ./cloud-init.nix { };
  cloud-init-hostname = handleTest ./cloud-init-hostname.nix { };
  cloudlog = handleTest ./cloudlog.nix { };
  cntr = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./cntr.nix { };
  cockpit = handleTest ./cockpit.nix { };
  cockroachdb = handleTestOn [ "x86_64-linux" ] ./cockroachdb.nix { };
  code-server = handleTest ./code-server.nix { };
  coder = handleTest ./coder.nix { };
  collectd = handleTest ./collectd.nix { };
  commafeed = handleTest ./commafeed.nix { };
  connman = handleTest ./connman.nix { };
  consul = handleTest ./consul.nix { };
  consul-template = handleTest ./consul-template.nix { };
  containers-bridge = handleTest ./containers-bridge.nix { };
  containers-custom-pkgs.nix = handleTest ./containers-custom-pkgs.nix { };
  containers-ephemeral = handleTest ./containers-ephemeral.nix { };
  containers-extra_veth = handleTest ./containers-extra_veth.nix { };
  containers-hosts = handleTest ./containers-hosts.nix { };
  containers-imperative = handleTest ./containers-imperative.nix { };
  containers-ip = handleTest ./containers-ip.nix { };
  containers-macvlans = handleTest ./containers-macvlans.nix { };
  containers-names = handleTest ./containers-names.nix { };
  containers-nested = handleTest ./containers-nested.nix { };
  containers-physical_interfaces = handleTest ./containers-physical_interfaces.nix { };
  containers-portforward = handleTest ./containers-portforward.nix { };
  containers-reloadable = handleTest ./containers-reloadable.nix { };
  containers-require-bind-mounts = handleTest ./containers-require-bind-mounts.nix { };
  containers-restart_networking = handleTest ./containers-restart_networking.nix { };
  containers-tmpfs = handleTest ./containers-tmpfs.nix { };
  containers-unified-hierarchy = handleTest ./containers-unified-hierarchy.nix { };
  convos = handleTest ./convos.nix { };
  corerad = handleTest ./corerad.nix { };
  cosmic = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic";
    _module.args.enableAutologin = false;
    _module.args.enableXWayland = true;
  };
  cosmic-autologin = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic-autologin";
    _module.args.enableAutologin = true;
    _module.args.enableXWayland = true;
  };
  cosmic-autologin-noxwayland = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic-autologin-noxwayland";
    _module.args.enableAutologin = true;
    _module.args.enableXWayland = false;
  };
  cosmic-noxwayland = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic-noxwayland";
    _module.args.enableAutologin = false;
    _module.args.enableXWayland = false;
  };
  coturn = handleTest ./coturn.nix { };
  couchdb = handleTest ./couchdb.nix { };
  crabfit = handleTest ./crabfit.nix { };
  cri-o = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./cri-o.nix { };
  croc = handleTest ./croc.nix { };
  cross-seed = runTest ./cross-seed.nix;
  cryptpad = runTest ./cryptpad.nix;
  cups-pdf = runTest ./cups-pdf.nix;
  curl-impersonate = handleTest ./curl-impersonate.nix { };
  custom-ca = handleTest ./custom-ca.nix { };
  cyrus-imap = runTest ./cyrus-imap.nix;
  dae = handleTest ./dae.nix { };
  darling-dmg = runTest ./darling-dmg.nix;
  davis = runTest ./davis.nix;
  db-rest = handleTest ./db-rest.nix { };
  dconf = handleTest ./dconf.nix { };
  ddns-updater = handleTest ./ddns-updater.nix { };
  deconz = handleTest ./deconz.nix { };
  deepin = handleTest ./deepin.nix { };
  deluge = handleTest ./deluge.nix { };
  dendrite = handleTest ./matrix/dendrite.nix { };
  dependency-track = handleTest ./dependency-track.nix { };
  devpi-server = handleTest ./devpi-server.nix { };
  dex-oidc = handleTest ./dex-oidc.nix { };
  dhparams = handleTest ./dhparams.nix { };
  disable-installer-tools = handleTest ./disable-installer-tools.nix { };
  discourse = handleTest ./discourse.nix { };
  dnscrypt-proxy2 = handleTestOn [ "x86_64-linux" ] ./dnscrypt-proxy2.nix { };
  dnsdist = import ./dnsdist.nix { inherit pkgs runTest; };
  doas = runTest ./doas.nix;
  docker = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker.nix;
  docker-registry = runTest ./docker-registry.nix;
  docker-rootless = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker-rootless.nix;
  docker-tools = handleTestOn [ "x86_64-linux" ] ./docker-tools.nix { };
  docker-tools-cross = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./docker-tools-cross.nix;
  docker-tools-nix-shell = runTest ./docker-tools-nix-shell.nix;
  docker-tools-overlay = runTestOn [ "x86_64-linux" ] ./docker-tools-overlay.nix;
  docling-serve = runTest ./docling-serve.nix;
  documentation = pkgs.callPackage ../modules/misc/documentation/test.nix { inherit nixosLib; };
  documize = handleTest ./documize.nix { };
  doh-proxy-rust = handleTest ./doh-proxy-rust.nix { };
  dokuwiki = runTest ./dokuwiki.nix;
  dolibarr = runTest ./dolibarr.nix;
  domination = handleTest ./domination.nix { };
  dovecot = handleTest ./dovecot.nix { };
  draupnir = runTest ./matrix/draupnir.nix;
  drawterm = discoverTests (import ./drawterm.nix);
  drbd = handleTest ./drbd.nix { };
  drbd-driver = handleTest ./drbd-driver.nix { };
  druid = handleTestOn [ "x86_64-linux" ] ./druid { };
  dublin-traceroute = handleTest ./dublin-traceroute.nix { };
  early-mount-options = handleTest ./early-mount-options.nix { };
  earlyoom = handleTestOn [ "x86_64-linux" ] ./earlyoom.nix { };
  ec2-config = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-config or { };
  ec2-nixops = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-nixops or { };
  echoip = runTest ./echoip.nix;
  ecryptfs = handleTest ./ecryptfs.nix { };
  eintopf = runTest ./eintopf.nix;
  ejabberd = handleTest ./xmpp/ejabberd.nix { };
  elk = handleTestOn [ "x86_64-linux" ] ./elk.nix { };
  emacs-daemon = runTest ./emacs-daemon.nix;
  endlessh = handleTest ./endlessh.nix { };
  endlessh-go = handleTest ./endlessh-go.nix { };
  engelsystem = handleTest ./engelsystem.nix { };
  enlightenment = handleTest ./enlightenment.nix { };
  env = handleTest ./env.nix { };
  envfs = handleTest ./envfs.nix { };
  envoy = runTest {
    imports = [ ./envoy.nix ];
    _module.args.envoyPackage = pkgs.envoy;
  };
  envoy-bin = runTest {
    imports = [ ./envoy.nix ];
    _module.args.envoyPackage = pkgs.envoy-bin;
  };
  ergo = handleTest ./ergo.nix { };
  ergochat = handleTest ./ergochat.nix { };
  eris-server = handleTest ./eris-server.nix { };
  esphome = handleTest ./esphome.nix { };
  etc = pkgs.callPackage ../modules/system/etc/test.nix { inherit evalMinimalConfig; };
  etcd = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./etcd/etcd.nix { };
  etcd-cluster = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./etcd/etcd-cluster.nix { };
  etebase-server = handleTest ./etebase-server.nix { };
  etesync-dav = handleTest ./etesync-dav.nix { };
  evcc = runTest ./evcc.nix;
  fail2ban = runTest ./fail2ban.nix;
  fakeroute = handleTest ./fakeroute.nix { };
  fancontrol = runTest ./fancontrol.nix;
  fanout = handleTest ./fanout.nix { };
  fastnetmon-advanced = runTest ./fastnetmon-advanced.nix;
  fcitx5 = handleTest ./fcitx5 { };
  fedimintd = runTest ./fedimintd.nix;
  fenics = handleTest ./fenics.nix { };
  ferm = handleTest ./ferm.nix { };
  ferretdb = handleTest ./ferretdb.nix { };
  fider = runTest ./fider.nix;
  filesender = handleTest ./filesender.nix { };
  filesystems-overlayfs = runTest ./filesystems-overlayfs.nix;
  firefly-iii = runTest ./firefly-iii.nix;
  firefly-iii-data-importer = runTest ./firefly-iii-data-importer.nix;
  firefox = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox;
  };
  firefox-beta = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-beta;
  };
  firefox-devedition = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-devedition;
  };
  firefox-esr = runTest {
    # used in `tested` job
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-esr;
  };
  firefox-esr-140 = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-esr-140;
  };
  firefoxpwa = handleTest ./firefoxpwa.nix { };
  firejail = handleTest ./firejail.nix { };
  firewall = handleTest ./firewall.nix { nftables = false; };
  firewall-nftables = handleTest ./firewall.nix { nftables = true; };
  firezone = handleTest ./firezone/firezone.nix { };
  fish = runTest ./fish.nix;
  flannel = handleTestOn [ "x86_64-linux" ] ./flannel.nix { };
  flaresolverr = handleTest ./flaresolverr.nix { };
  flood = handleTest ./flood.nix { };
  floorp = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.floorp;
  };
  fluent-bit = runTest ./fluent-bit.nix;
  fluentd = handleTest ./fluentd.nix { };
  fluidd = handleTest ./fluidd.nix { };
  fontconfig-default-fonts = handleTest ./fontconfig-default-fonts.nix { };
  forgejo = import ./forgejo.nix {
    inherit runTest;
    forgejoPackage = pkgs.forgejo;
  };
  forgejo-lts = import ./forgejo.nix {
    inherit runTest;
    forgejoPackage = pkgs.forgejo-lts;
  };
  freenet = runTest ./freenet.nix;
  freeswitch = handleTest ./freeswitch.nix { };
  freetube = discoverTests (import ./freetube.nix);
  freshrss = import ./freshrss { inherit runTest; };
  frigate = runTest ./frigate.nix;
  froide-govplan = runTest ./web-apps/froide-govplan.nix;
  frp = handleTest ./frp.nix { };
  frr = handleTest ./frr.nix { };
  fsck = handleTest ./fsck.nix { };
  fsck-systemd-stage-1 = handleTest ./fsck.nix { systemdStage1 = true; };
  fscrypt = handleTest ./fscrypt.nix { };
  ft2-clone = handleTest ./ft2-clone.nix { };
  gancio = handleTest ./gancio.nix { };
  garage_1 = import ./garage {
    inherit runTest;
    package = pkgs.garage_1;
  };
  garage_2 = import ./garage {
    inherit runTest;
    package = pkgs.garage_2;
  };
  gatus = runTest ./gatus.nix;
  gemstash = handleTest ./gemstash.nix { };
  geoclue2 = runTest ./geoclue2.nix;
  geoserver = runTest ./geoserver.nix;
  gerrit = runTest ./gerrit.nix;
  geth = handleTest ./geth.nix { };
  ghostunnel = handleTest ./ghostunnel.nix { };
  gitdaemon = handleTest ./gitdaemon.nix { };
  gitea = handleTest ./gitea.nix { giteaPackage = pkgs.gitea; };
  github-runner = runTest ./github-runner.nix;
  gitlab = runTest ./gitlab.nix;
  gitolite = handleTest ./gitolite.nix { };
  gitolite-fcgiwrap = handleTest ./gitolite-fcgiwrap.nix { };
  glance = runTest ./glance.nix;
  glances = runTest ./glances.nix;
  glitchtip = runTest ./glitchtip.nix;
  glusterfs = handleTest ./glusterfs.nix { };
  gnome = runTest ./gnome.nix;
  gnome-extensions = handleTest ./gnome-extensions.nix { };
  gnome-flashback = handleTest ./gnome-flashback.nix { };
  gnome-xorg = handleTest ./gnome-xorg.nix { };
  gns3-server = handleTest ./gns3-server.nix { };
  gnupg = handleTest ./gnupg.nix { };
  go-camo = handleTest ./go-camo.nix { };
  go-httpbin = runTest ./go-httpbin.nix;
  go-neb = runTest ./go-neb.nix;
  goatcounter = handleTest ./goatcounter.nix { };
  gobgpd = handleTest ./gobgpd.nix { };
  gocd-agent = handleTest ./gocd-agent.nix { };
  gocd-server = handleTest ./gocd-server.nix { };
  gokapi = runTest ./gokapi.nix;
  gollum = handleTest ./gollum.nix { };
  gonic = handleTest ./gonic.nix { };
  google-oslogin = handleTest ./google-oslogin { };
  gopro-tool = handleTest ./gopro-tool.nix { };
  goss = handleTest ./goss.nix { };
  gotenberg = handleTest ./gotenberg.nix { };
  gotify-server = handleTest ./gotify-server.nix { };
  gotosocial = runTest ./web-apps/gotosocial.nix;
  grafana = handleTest ./grafana { };
  graphite = handleTest ./graphite.nix { };
  grav = runTest ./web-apps/grav.nix;
  graylog = handleTest ./graylog.nix { };
  greetd-no-shadow = handleTest ./greetd-no-shadow.nix { };
  grocy = runTest ./grocy.nix;
  grow-partition = runTest ./grow-partition.nix;
  grub = handleTest ./grub.nix { };
  guacamole-server = handleTest ./guacamole-server.nix { };
  guix = handleTest ./guix { };
  gvisor = handleTest ./gvisor.nix { };
  h2o = import ./web-servers/h2o { inherit recurseIntoAttrs runTest; };
  hadoop = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop;
  };
  hadoop2 = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop2;
  };
  hadoop_3_3 = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop_3_3;
  };
  haproxy = runTest ./haproxy.nix;
  hardened = handleTest ./hardened.nix { };
  harmonia = runTest ./harmonia.nix;
  haste-server = handleTest ./haste-server.nix { };
  hbase2 = handleTest ./hbase.nix { package = pkgs.hbase2; };
  hbase3 = handleTest ./hbase.nix { package = pkgs.hbase3; };
  hbase_2_4 = handleTest ./hbase.nix { package = pkgs.hbase_2_4; };
  hbase_2_5 = handleTest ./hbase.nix { package = pkgs.hbase_2_5; };
  headscale = handleTest ./headscale.nix { };
  healthchecks = handleTest ./web-apps/healthchecks.nix { };
  hedgedoc = handleTest ./hedgedoc.nix { };
  herbstluftwm = handleTest ./herbstluftwm.nix { };
  # 9pnet_virtio used to mount /nix partition doesn't support
  # hibernation. This test happens to work on x86_64-linux but
  # not on other platforms.
  hibernate = handleTestOn [ "x86_64-linux" ] ./hibernate.nix { };
  hibernate-systemd-stage-1 = handleTestOn [ "x86_64-linux" ] ./hibernate.nix {
    systemdStage1 = true;
  };
  hitch = handleTest ./hitch { };
  hledger-web = handleTest ./hledger-web.nix { };
  hockeypuck = handleTest ./hockeypuck.nix { };
  home-assistant = runTest ./home-assistant.nix;
  homebox = handleTest ./homebox.nix { };
  homepage-dashboard = runTest ./homepage-dashboard.nix;
  homer = handleTest ./homer { };
  honk = runTest ./honk.nix;
  hostname = handleTest ./hostname.nix { };
  hound = handleTest ./hound.nix { };
  hub = runTest ./git/hub.nix;
  hydra = runTest ./hydra;
  i18n = runTest ./i18n.nix;
  i3wm = handleTest ./i3wm.nix { };
  icingaweb2 = runTest ./icingaweb2.nix;
  ifm = handleTest ./ifm.nix { };
  iftop = handleTest ./iftop.nix { };
  image-contents = handleTest ./image-contents.nix { };
  immich = handleTest ./web-apps/immich.nix { };
  immich-public-proxy = handleTest ./web-apps/immich-public-proxy.nix { };
  immich-vectorchord-migration = runTest ./web-apps/immich-vectorchord-migration.nix;
  incron = handleTest ./incron.nix { };
  incus = pkgs.recurseIntoAttrs (
    handleTest ./incus {
      lts = false;
      inherit system pkgs;
    }
  );
  incus-lts = pkgs.recurseIntoAttrs (handleTest ./incus { inherit system pkgs; });
  influxdb = handleTest ./influxdb.nix { };
  influxdb2 = handleTest ./influxdb2.nix { };
  initrd-luks-empty-passphrase = handleTest ./initrd-luks-empty-passphrase.nix { };
  initrd-network-openvpn = handleTestOn [ "x86_64-linux" "i686-linux" ] ./initrd-network-openvpn { };
  initrd-network-ssh = handleTest ./initrd-network-ssh { };
  initrd-secrets = handleTest ./initrd-secrets.nix { };
  initrd-secrets-changing = handleTest ./initrd-secrets-changing.nix { };
  initrdNetwork = handleTest ./initrd-network.nix { };
  input-remapper = handleTest ./input-remapper.nix { };
  inspircd = handleTest ./inspircd.nix { };
  installed-tests = pkgs.recurseIntoAttrs (handleTest ./installed-tests { });
  installer = handleTest ./installer.nix { };
  installer-systemd-stage-1 = handleTest ./installer-systemd-stage-1.nix { };
  intune = handleTest ./intune.nix { };
  invidious = handleTest ./invidious.nix { };
  invoiceplane = runTest ./invoiceplane.nix;
  iodine = handleTest ./iodine.nix { };
  iosched = handleTest ./iosched.nix { };
  ipv6 = handleTest ./ipv6.nix { };
  iscsi-multipath-root = handleTest ./iscsi-multipath-root.nix { };
  iscsi-root = handleTest ./iscsi-root.nix { };
  isolate = handleTest ./isolate.nix { };
  isso = handleTest ./isso.nix { };
  jackett = handleTest ./jackett.nix { };
  jellyfin = handleTest ./jellyfin.nix { };
  jenkins = handleTest ./jenkins.nix { };
  jenkins-cli = handleTest ./jenkins-cli.nix { };
  jibri = handleTest ./jibri.nix { };
  jirafeau = handleTest ./jirafeau.nix { };
  jitsi-meet = handleTest ./jitsi-meet.nix { };
  jool = import ./jool.nix { inherit pkgs runTest; };
  jotta-cli = handleTest ./jotta-cli.nix { };
  k3s = handleTest ./k3s { };
  kafka = handleTest ./kafka { };
  kanboard = runTest ./web-apps/kanboard.nix;
  kanidm = handleTest ./kanidm.nix { };
  kanidm-provisioning = handleTest ./kanidm-provisioning.nix { };
  karma = handleTest ./karma.nix { };
  kavita = handleTest ./kavita.nix { };
  kbd-setfont-decompress = handleTest ./kbd-setfont-decompress.nix { };
  kbd-update-search-paths-patch = handleTest ./kbd-update-search-paths-patch.nix { };
  kea = runTest ./kea.nix;
  keepalived = handleTest ./keepalived.nix { };
  keepassxc = handleTest ./keepassxc.nix { };
  kerberos = handleTest ./kerberos/default.nix { };
  kernel-generic = handleTest ./kernel-generic.nix { };
  kernel-latest-ath-user-regd = handleTest ./kernel-latest-ath-user-regd.nix { };
  kernel-rust = handleTest ./kernel-rust.nix { };
  keter = handleTest ./keter.nix { };
  kexec = runTest ./kexec.nix;
  keycloak = discoverTests (import ./keycloak.nix);
  keyd = handleTest ./keyd.nix { };
  keymap = handleTest ./keymap.nix { };
  kimai = runTest ./kimai.nix;
  kismet = runTest ./kismet.nix;
  kmonad = runTest ./kmonad.nix;
  knot = runTest ./knot.nix;
  komga = handleTest ./komga.nix { };
  krb5 = discoverTests (import ./krb5);
  ksm = handleTest ./ksm.nix { };
  kthxbye = handleTest ./kthxbye.nix { };
  kubernetes = handleTestOn [ "x86_64-linux" ] ./kubernetes { };
  kubo = import ./kubo { inherit recurseIntoAttrs runTest; };
  ladybird = handleTest ./ladybird.nix { };
  languagetool = handleTest ./languagetool.nix { };
  lanraragi = handleTest ./lanraragi.nix { };
  latestKernel.login = handleTest ./login.nix { latestKernel = true; };
  lavalink = runTest ./lavalink.nix;
  leaps = handleTest ./leaps.nix { };
  legit = handleTest ./legit.nix { };
  lemmy = handleTest ./lemmy.nix { };
  libinput = handleTest ./libinput.nix { };
  librenms = runTest ./librenms.nix;
  libresprite = handleTest ./libresprite.nix { };
  libreswan = runTest ./libreswan.nix;
  libreswan-nat = runTest ./libreswan-nat.nix;
  librewolf = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.librewolf;
  };
  libuiohook = handleTest ./libuiohook.nix { };
  libvirtd = handleTest ./libvirtd.nix { };
  lidarr = handleTest ./lidarr.nix { };
  lightdm = handleTest ./lightdm.nix { };
  lighttpd = runTest ./lighttpd.nix;
  limesurvey = handleTest ./limesurvey.nix { };
  limine = import ./limine { inherit runTest; };
  listmonk = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./listmonk.nix { };
  litellm = runTest ./litellm.nix;
  litestream = handleTest ./litestream.nix { };
  livebook-service = handleTest ./livebook-service.nix { };
  livekit = runTest ./networking/livekit.nix;
  lk-jwt-service = runTest ./matrix/lk-jwt-service.nix;
  lldap = handleTest ./lldap.nix { };
  localsend = handleTest ./localsend.nix { };
  locate = handleTest ./locate.nix { };
  login = handleTest ./login.nix { };
  logrotate = runTest ./logrotate.nix;
  loki = handleTest ./loki.nix { };
  #logstash = handleTest ./logstash.nix {};
  lomiri = discoverTests (import ./lomiri.nix);
  lomiri-calculator-app = runTest ./lomiri-calculator-app.nix;
  lomiri-calendar-app = runTest ./lomiri-calendar-app.nix;
  lomiri-camera-app = discoverTests (import ./lomiri-camera-app.nix);
  lomiri-clock-app = runTest ./lomiri-clock-app.nix;
  lomiri-docviewer-app = runTest ./lomiri-docviewer-app.nix;
  lomiri-filemanager-app = runTest ./lomiri-filemanager-app.nix;
  lomiri-gallery-app = discoverTests (import ./lomiri-gallery-app.nix);
  lomiri-mediaplayer-app = runTest ./lomiri-mediaplayer-app.nix;
  lomiri-music-app = runTest ./lomiri-music-app.nix;
  lomiri-system-settings = runTest ./lomiri-system-settings.nix;
  lorri = handleTest ./lorri/default.nix { };
  luks = handleTest ./luks.nix { };
  lvm2 = handleTest ./lvm2 { };
  lxc = handleTest ./lxc { };
  lxd = pkgs.recurseIntoAttrs (handleTest ./lxd { inherit handleTestOn; });
  lxd-image-server = handleTest ./lxd-image-server.nix { };
  lxqt = handleTest ./lxqt.nix { };
  ly = handleTest ./ly.nix { };
  maddy = discoverTests (import ./maddy { inherit handleTest; });
  maestral = handleTest ./maestral.nix { };
  magic-wormhole-mailbox-server = runTest ./magic-wormhole-mailbox-server.nix;
  magnetico = handleTest ./magnetico.nix { };
  mailcatcher = runTest ./mailcatcher.nix;
  mailhog = runTest ./mailhog.nix;
  mailman = runTest ./mailman.nix;
  mailpit = runTest ./mailpit.nix;
  man = runTest ./man.nix;
  mariadb-galera = handleTest ./mysql/mariadb-galera.nix { };
  marytts = handleTest ./marytts.nix { };
  mastodon = pkgs.recurseIntoAttrs (handleTest ./web-apps/mastodon { inherit handleTestOn; });
  mate = handleTest ./mate.nix { };
  mate-wayland = handleTest ./mate-wayland.nix { };
  matomo = runTest ./matomo.nix;
  matrix-alertmanager = runTest ./matrix/matrix-alertmanager.nix;
  matrix-appservice-irc = runTest ./matrix/appservice-irc.nix;
  matrix-conduit = handleTest ./matrix/conduit.nix { };
  matrix-continuwuity = runTest ./matrix/continuwuity.nix;
  matrix-synapse = handleTest ./matrix/synapse.nix { };
  matrix-synapse-workers = handleTest ./matrix/synapse-workers.nix { };
  matter-server = handleTest ./matter-server.nix { };
  mattermost = handleTest ./mattermost { };
  mautrix-meta-postgres = handleTest ./matrix/mautrix-meta-postgres.nix { };
  mautrix-meta-sqlite = handleTest ./matrix/mautrix-meta-sqlite.nix { };
  mealie = handleTest ./mealie.nix { };
  mediamtx = handleTest ./mediamtx.nix { };
  mediatomb = handleTest ./mediatomb.nix { };
  mediawiki = handleTest ./mediawiki.nix { };
  meilisearch = handleTest ./meilisearch.nix { };
  memcached = runTest ./memcached.nix;
  merecat = handleTest ./merecat.nix { };
  metabase = handleTest ./metabase.nix { };
  mihomo = handleTest ./mihomo.nix { };
  mimir = handleTest ./mimir.nix { };
  mindustry = handleTest ./mindustry.nix { };
  minecraft = handleTest ./minecraft.nix { };
  minecraft-server = handleTest ./minecraft-server.nix { };
  minidlna = handleTest ./minidlna.nix { };
  miniflux = handleTest ./miniflux.nix { };
  minio = handleTest ./minio.nix { };
  miracle-wm = runTest ./miracle-wm.nix;
  miriway = runTest ./miriway.nix;
  misc = handleTest ./misc.nix { };
  misskey = handleTest ./misskey.nix { };
  mjolnir = handleTest ./matrix/mjolnir.nix { };
  mobilizon = runTest ./mobilizon.nix;
  mod_perl = handleTest ./mod_perl.nix { };
  molly-brown = handleTest ./molly-brown.nix { };
  mollysocket = handleTest ./mollysocket.nix { };
  monado = handleTest ./monado.nix { };
  monetdb = handleTest ./monetdb.nix { };
  mongodb = runTest ./mongodb.nix;
  mongodb-ce = runTest (
    { config, ... }:
    {
      imports = [ ./mongodb.nix ];
      defaults.services.mongodb.package = config.node.pkgs.mongodb-ce;
    }
  );
  monica = runTest ./web-apps/monica.nix;
  moodle = runTest ./moodle.nix;
  moonraker = handleTest ./moonraker.nix { };
  moosefs = handleTest ./moosefs.nix { };
  mopidy = handleTest ./mopidy.nix { };
  morph-browser = runTest ./morph-browser.nix;
  morty = handleTest ./morty.nix { };
  mosquitto = runTest ./mosquitto.nix;
  movim = import ./web-apps/movim { inherit recurseIntoAttrs runTest; };
  mpd = runTest ./mpd.nix;
  mpv = runTest ./mpv.nix;
  mtp = handleTest ./mtp.nix { };
  multipass = handleTest ./multipass.nix { };
  mumble = runTest ./mumble.nix;
  munin = handleTest ./munin.nix { };
  # Fails on aarch64-linux at the PDF creation step - need to debug this on an
  # aarch64 machine..
  musescore = handleTestOn [ "x86_64-linux" ] ./musescore.nix { };
  music-assistant = runTest ./music-assistant.nix;
  mutableUsers = handleTest ./mutable-users.nix { };
  mycelium = handleTest ./mycelium { };
  mympd = handleTest ./mympd.nix { };
  mysql = handleTest ./mysql/mysql.nix { };
  mysql-autobackup = handleTest ./mysql/mysql-autobackup.nix { };
  mysql-backup = handleTest ./mysql/mysql-backup.nix { };
  mysql-replication = handleTest ./mysql/mysql-replication.nix { };
  n8n = runTest ./n8n.nix;
  nagios = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./nagios.nix { };
  nar-serve = handleTest ./nar-serve.nix { };
  nat.firewall = handleTest ./nat.nix { withFirewall = true; };
  nat.nftables.firewall = handleTest ./nat.nix {
    withFirewall = true;
    nftables = true;
  };
  nat.nftables.standalone = handleTest ./nat.nix {
    withFirewall = false;
    nftables = true;
  };
  nat.standalone = handleTest ./nat.nix { withFirewall = false; };
  nats = handleTest ./nats.nix { };
  navidrome = handleTest ./navidrome.nix { };
  nbd = handleTest ./nbd.nix { };
  ncdns = handleTest ./ncdns.nix { };
  ncps = runTest ./ncps.nix;
  ncps-custom-cache-datapath = runTest {
    imports = [ ./ncps.nix ];
    defaults.services.ncps.cache.dataPath = "/path/to/ncps";
  };
  ndppd = handleTest ./ndppd.nix { };
  nebula = handleTest ./nebula.nix { };
  neo4j = handleTest ./neo4j.nix { };
  netbird = handleTest ./netbird.nix { };
  netbox-upgrade = handleTest ./web-apps/netbox-upgrade.nix { };
  netbox_3_7 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_3_7; };
  netbox_4_1 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_1; };
  netbox_4_2 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_2; };
  netdata = handleTest ./netdata.nix { };
  networking.networkd = handleTest ./networking/networkd-and-scripted.nix { networkd = true; };
  networking.networkmanager = handleTest ./networking/networkmanager.nix { };
  networking.scripted = handleTest ./networking/networkd-and-scripted.nix { networkd = false; };
  # TODO: put in networking.nix after the test becomes more complete
  networkingProxy = handleTest ./networking-proxy.nix { };
  nextcloud = handleTest ./nextcloud { };
  nextflow = runTestOn [ "x86_64-linux" ] ./nextflow.nix;
  nextjs-ollama-llm-ui = runTest ./web-apps/nextjs-ollama-llm-ui.nix;
  nexus = handleTest ./nexus.nix { };
  # TODO: Test nfsv3 + Kerberos
  nfs3 = handleTest ./nfs { version = 3; };
  nfs4 = handleTest ./nfs { version = 4; };
  nghttpx = handleTest ./nghttpx.nix { };
  nginx = runTest ./nginx.nix;
  nginx-auth = runTest ./nginx-auth.nix;
  nginx-etag = runTest ./nginx-etag.nix;
  nginx-etag-compression = runTest ./nginx-etag-compression.nix;
  nginx-globalredirect = runTest ./nginx-globalredirect.nix;
  nginx-http3 = import ./nginx-http3.nix { inherit pkgs runTest; };
  nginx-mime = runTest ./nginx-mime.nix;
  nginx-modsecurity = runTest ./nginx-modsecurity.nix;
  nginx-moreheaders = runTest ./nginx-moreheaders.nix;
  nginx-njs = handleTest ./nginx-njs.nix { };
  nginx-proxyprotocol = runTest ./nginx-proxyprotocol/default.nix;
  nginx-pubhtml = runTest ./nginx-pubhtml.nix;
  nginx-redirectcode = runTest ./nginx-redirectcode.nix;
  nginx-sso = runTest ./nginx-sso.nix;
  nginx-status-page = runTest ./nginx-status-page.nix;
  nginx-tmpdir = runTest ./nginx-tmpdir.nix;
  nginx-unix-socket = runTest ./nginx-unix-socket.nix;
  nginx-variants = import ./nginx-variants.nix { inherit pkgs runTest; };
  nifi = runTestOn [ "x86_64-linux" ] ./web-apps/nifi.nix;
  nimdow = handleTest ./nimdow.nix { };
  nitter = handleTest ./nitter.nix { };
  nix-channel = pkgs.callPackage ../modules/config/nix-channel/test.nix { };
  nix-config = handleTest ./nix-config.nix { };
  nix-ld = runTest ./nix-ld.nix;
  nix-misc = handleTest ./nix/misc.nix { };
  nix-required-mounts = runTest ./nix-required-mounts;
  nix-serve = runTest ./nix-serve.nix;
  nix-serve-ssh = handleTest ./nix-serve-ssh.nix { };
  nix-upgrade = handleTest ./nix/upgrade.nix { inherit (pkgs) nixVersions; };
  nixops = handleTest ./nixops/default.nix { };
  nixos-generate-config = handleTest ./nixos-generate-config.nix { };
  nixos-rebuild-install-bootloader = handleTestOn [
    "x86_64-linux"
  ] ./nixos-rebuild-install-bootloader.nix { };
  nixos-rebuild-install-bootloader-ng = handleTestOn [
    "x86_64-linux"
  ] ./nixos-rebuild-install-bootloader.nix { withNg = true; };
  nixos-rebuild-specialisations = runTestOn [ "x86_64-linux" ] {
    imports = [ ./nixos-rebuild-specialisations.nix ];
    _module.args.withNg = false;
  };
  nixos-rebuild-specialisations-ng = runTestOn [ "x86_64-linux" ] {
    imports = [ ./nixos-rebuild-specialisations.nix ];
    _module.args.withNg = true;
  };
  nixos-rebuild-target-host = runTest {
    imports = [ ./nixos-rebuild-target-host.nix ];
    _module.args.withNg = false;
  };
  nixos-rebuild-target-host-ng = runTest {
    imports = [ ./nixos-rebuild-target-host.nix ];
    _module.args.withNg = true;
  };
  nixpkgs = pkgs.callPackage ../modules/misc/nixpkgs/test.nix { inherit evalMinimalConfig; };
  nixseparatedebuginfod = handleTest ./nixseparatedebuginfod.nix { };
  node-red = runTest ./node-red.nix;
  nomad = runTest ./nomad.nix;
  non-default-filesystems = handleTest ./non-default-filesystems.nix { };
  non-switchable-system = runTest ./non-switchable-system.nix;
  noto-fonts = runTest ./noto-fonts.nix;
  noto-fonts-cjk-qt-default-weight = handleTest ./noto-fonts-cjk-qt-default-weight.nix { };
  novacomd = handleTestOn [ "x86_64-linux" ] ./novacomd.nix { };
  npmrc = handleTest ./npmrc.nix { };
  nscd = handleTest ./nscd.nix { };
  nsd = handleTest ./nsd.nix { };
  ntfy-sh = handleTest ./ntfy-sh.nix { };
  ntfy-sh-migration = handleTest ./ntfy-sh-migration.nix { };
  ntpd = handleTest ./ntpd.nix { };
  ntpd-rs = handleTest ./ntpd-rs.nix { };
  nvidia-container-toolkit = runTest ./nvidia-container-toolkit.nix;
  nvmetcfg = handleTest ./nvmetcfg.nix { };
  nzbget = handleTest ./nzbget.nix { };
  nzbhydra2 = handleTest ./nzbhydra2.nix { };
  obs-studio = runTest ./obs-studio.nix;
  oci-containers = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./oci-containers.nix { };
  ocis = handleTest ./ocis.nix { };
  ocsinventory-agent = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./ocsinventory-agent.nix { };
  octoprint = handleTest ./octoprint.nix { };
  oddjobd = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./oddjobd.nix { };
  odoo = handleTest ./odoo.nix { };
  odoo16 = handleTest ./odoo.nix { package = pkgs.odoo16; };
  odoo17 = handleTest ./odoo.nix { package = pkgs.odoo17; };
  oh-my-zsh = handleTest ./oh-my-zsh.nix { };
  olivetin = runTest ./olivetin.nix;
  ollama = runTest ./ollama.nix;
  ollama-cuda = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-cuda.nix;
  ollama-rocm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-rocm.nix;
  ombi = handleTest ./ombi.nix { };
  omnom = runTest ./omnom.nix;
  oncall = runTest ./web-apps/oncall.nix;
  open-web-calendar = handleTest ./web-apps/open-web-calendar.nix { };
  open-webui = runTest ./open-webui.nix;
  openarena = handleTest ./openarena.nix { };
  openbao = runTest ./openbao.nix;
  openldap = handleTest ./openldap.nix { };
  openresty-lua = handleTest ./openresty-lua.nix { };
  opensearch = discoverTests (import ./opensearch.nix);
  opensmtpd = handleTest ./opensmtpd.nix { };
  opensmtpd-rspamd = handleTest ./opensmtpd-rspamd.nix { };
  opensnitch = handleTest ./opensnitch.nix { };
  openssh = handleTest ./openssh.nix { };
  openstack-image-metadata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).metadata or { };
  openstack-image-userdata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).userdata or { };
  opentabletdriver = handleTest ./opentabletdriver.nix { };
  opentelemetry-collector = handleTest ./opentelemetry-collector.nix { };
  openvscode-server = handleTest ./openvscode-server.nix { };
  openvswitch = runTest ./openvswitch.nix;
  orangefs = handleTest ./orangefs.nix { };
  orthanc = runTest ./orthanc.nix;
  os-prober = handleTestOn [ "x86_64-linux" ] ./os-prober.nix { };
  osquery = handleTestOn [ "x86_64-linux" ] ./osquery.nix { };
  osrm-backend = handleTest ./osrm-backend.nix { };
  outline = handleTest ./outline.nix { };
  overlayfs = handleTest ./overlayfs.nix { };
  owncast = handleTest ./owncast.nix { };
  pacemaker = handleTest ./pacemaker.nix { };
  packagekit = handleTest ./packagekit.nix { };
  pam-file-contents = handleTest ./pam/pam-file-contents.nix { };
  pam-oath-login = handleTest ./pam/pam-oath-login.nix { };
  pam-u2f = handleTest ./pam/pam-u2f.nix { };
  pam-ussh = handleTest ./pam/pam-ussh.nix { };
  pam-zfs-key = handleTest ./pam/zfs-key.nix { };
  pantalaimon = handleTest ./matrix/pantalaimon.nix { };
  pantheon = handleTest ./pantheon.nix { };
  pantheon-wayland = handleTest ./pantheon-wayland.nix { };
  paperless = handleTest ./paperless.nix { };
  paretosecurity = runTest ./paretosecurity.nix;
  parsedmarc = handleTest ./parsedmarc { };
  pass-secret-service = handleTest ./pass-secret-service.nix { };
  password-option-override-ordering = handleTest ./password-option-override-ordering.nix { };
  patroni = handleTestOn [ "x86_64-linux" ] ./patroni.nix { };
  pdns-recursor = runTest ./pdns-recursor.nix;
  pds = handleTest ./pds.nix { };
  peerflix = handleTest ./peerflix.nix { };
  peering-manager = handleTest ./web-apps/peering-manager.nix { };
  peertube = handleTestOn [ "x86_64-linux" ] ./web-apps/peertube.nix { };
  peroxide = handleTest ./peroxide.nix { };
  pgadmin4 = runTest ./pgadmin4.nix;
  pgbackrest = import ./pgbackrest { inherit runTest; };
  pgbouncer = handleTest ./pgbouncer.nix { };
  pghero = runTest ./pghero.nix;
  pgmanage = handleTest ./pgmanage.nix { };
  pgweb = runTest ./pgweb.nix;
  phosh = handleTest ./phosh.nix { };
  photonvision = handleTest ./photonvision.nix { };
  photoprism = handleTest ./photoprism.nix { };
  php = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php;
  };
  php81 = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php81;
  };
  php82 = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php82;
  };
  php83 = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php83;
  };
  php84 = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php84;
  };
  phylactery = handleTest ./web-apps/phylactery.nix { };
  pict-rs = handleTest ./pict-rs.nix { };
  pingvin-share = handleTest ./pingvin-share.nix { };
  pinnwand = runTest ./pinnwand.nix;
  pixelfed = import ./web-apps/pixelfed { inherit runTestOn; };
  plantuml-server = handleTest ./plantuml-server.nix { };
  plasma-bigscreen = handleTest ./plasma-bigscreen.nix { };
  plasma5 = handleTest ./plasma5.nix { };
  plasma5-systemd-start = handleTest ./plasma5-systemd-start.nix { };
  plasma6 = handleTest ./plasma6.nix { };
  plausible = handleTest ./plausible.nix { };
  playwright-python = handleTest ./playwright-python.nix { };
  please = handleTest ./please.nix { };
  pleroma = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./pleroma.nix { };
  plikd = handleTest ./plikd.nix { };
  plotinus = handleTest ./plotinus.nix { };
  pocket-id = handleTest ./pocket-id.nix { };
  podgrab = handleTest ./podgrab.nix { };
  podman = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./podman/default.nix { };
  podman-tls-ghostunnel = handleTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./podman/tls-ghostunnel.nix { };
  polaris = handleTest ./polaris.nix { };
  pomerium = handleTestOn [ "x86_64-linux" ] ./pomerium.nix { };
  portunus = handleTest ./portunus.nix { };
  postfix = handleTest ./postfix.nix { };
  postfix-raise-smtpd-tls-security-level =
    handleTest ./postfix-raise-smtpd-tls-security-level.nix
      { };
  postfix-tlspol = runTest ./postfix-tlspol.nix;
  postfixadmin = handleTest ./postfixadmin.nix { };
  postgres-websockets = runTest ./postgres-websockets.nix;
  postgresql = handleTest ./postgresql { };
  postgrest = runTest ./postgrest.nix;
  power-profiles-daemon = handleTest ./power-profiles-daemon.nix { };
  powerdns = handleTest ./powerdns.nix { };
  powerdns-admin = handleTest ./powerdns-admin.nix { };
  pppd = handleTest ./pppd.nix { };
  predictable-interface-names = handleTest ./predictable-interface-names.nix { };
  prefect = runTest ./prefect.nix;
  pretalx = runTest ./web-apps/pretalx.nix;
  pretix = runTest ./web-apps/pretix.nix;
  printing-service = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = false;
    _module.args.listenTcp = true;
  };
  printing-service-notcp = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = false;
    _module.args.listenTcp = false;
  };
  printing-socket = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = true;
    _module.args.listenTcp = true;
  };
  printing-socket-notcp = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = true;
    _module.args.listenTcp = false;
  };
  private-gpt = handleTest ./private-gpt.nix { };
  privatebin = runTest ./privatebin.nix;
  privoxy = handleTest ./privoxy.nix { };
  prometheus = import ./prometheus { inherit runTest; };
  prometheus-exporters = handleTest ./prometheus-exporters.nix { };
  prosody = handleTest ./xmpp/prosody.nix { };
  prosody-mysql = handleTest ./xmpp/prosody-mysql.nix { };
  prowlarr = handleTest ./prowlarr.nix { };
  proxy = handleTest ./proxy.nix { };
  pt2-clone = handleTest ./pt2-clone.nix { };
  public-inbox = handleTest ./public-inbox.nix { };
  pufferpanel = handleTest ./pufferpanel.nix { };
  pulseaudio = discoverTests (import ./pulseaudio.nix);
  pykms = handleTest ./pykms.nix { };
  pyload = handleTest ./pyload.nix { };
  qbittorrent = runTest ./qbittorrent.nix;
  qboot = handleTestOn [ "x86_64-linux" "i686-linux" ] ./qboot.nix { };
  qemu-vm-external-disk-image = runTest ./qemu-vm-external-disk-image.nix;
  qemu-vm-restrictnetwork = handleTest ./qemu-vm-restrictnetwork.nix { };
  qemu-vm-store = runTest ./qemu-vm-store.nix;
  qemu-vm-volatile-root = runTest ./qemu-vm-volatile-root.nix;
  qgis = handleTest ./qgis.nix { package = pkgs.qgis; };
  qgis-ltr = handleTest ./qgis.nix { package = pkgs.qgis-ltr; };
  qownnotes = handleTest ./qownnotes.nix { };
  qtile = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./qtile/default.nix;
  quake3 = handleTest ./quake3.nix { };
  quicktun = handleTest ./quicktun.nix { };
  quickwit = handleTest ./quickwit.nix { };
  quorum = handleTest ./quorum.nix { };
  rabbitmq = handleTest ./rabbitmq.nix { };
  radarr = handleTest ./radarr.nix { };
  radicale = handleTest ./radicale.nix { };
  radicle = runTest ./radicle.nix;
  radicle-ci-broker = runTest ./radicle-ci-broker.nix;
  ragnarwm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ragnarwm.nix;
  rasdaemon = handleTest ./rasdaemon.nix { };
  rathole = runTest ./rathole.nix;
  readarr = handleTest ./readarr.nix { };
  readeck = runTest ./readeck.nix;
  realm = handleTest ./realm.nix { };
  rebuilderd = runTest ./rebuilderd.nix;
  redis = handleTest ./redis.nix { };
  redlib = handleTest ./redlib.nix { };
  redmine = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./redmine.nix { };
  renovate = handleTest ./renovate.nix { };
  replace-dependencies = handleTest ./replace-dependencies { };
  reposilite = runTest ./reposilite.nix;
  restartByActivationScript = handleTest ./restart-by-activation-script.nix { };
  restic = handleTest ./restic.nix { };
  restic-rest-server = handleTest ./restic-rest-server.nix { };
  retroarch = handleTest ./retroarch.nix { };
  rke2 = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./rke2 { };
  rkvm = handleTest ./rkvm { };
  rmfakecloud = runTest ./rmfakecloud.nix;
  robustirc-bridge = handleTest ./robustirc-bridge.nix { };
  rosenpass = handleTest ./rosenpass.nix { };
  roundcube = handleTest ./roundcube.nix { };
  routinator = handleTest ./routinator.nix { };
  rshim = handleTest ./rshim.nix { };
  rspamd = handleTest ./rspamd.nix { };
  rspamd-trainer = handleTest ./rspamd-trainer.nix { };
  rss-bridge = handleTest ./web-apps/rss-bridge { };
  rss2email = handleTest ./rss2email.nix { };
  rstudio-server = handleTest ./rstudio-server.nix { };
  rsyncd = handleTest ./rsyncd.nix { };
  rsyslogd = handleTest ./rsyslogd.nix { };
  rtkit = runTest ./rtkit.nix;
  rtorrent = handleTest ./rtorrent.nix { };
  rush = runTest ./rush.nix;
  rustls-libssl = handleTest ./rustls-libssl.nix { };
  rxe = handleTest ./rxe.nix { };
  sabnzbd = handleTest ./sabnzbd.nix { };
  samba = runTest ./samba.nix;
  samba-wsdd = handleTest ./samba-wsdd.nix { };
  sane = handleTest ./sane.nix { };
  sanoid = handleTest ./sanoid.nix { };
  saunafs = handleTest ./saunafs.nix { };
  scaphandre = handleTest ./scaphandre.nix { };
  schleuder = handleTest ./schleuder.nix { };
  scion-freestanding-deployment = handleTest ./scion/freestanding-deployment { };
  scrutiny = runTest ./scrutiny.nix;
  scx = runTest ./scx/default.nix;
  sddm = handleTest ./sddm.nix { };
  sdl3 = handleTest ./sdl3.nix { };
  seafile = handleTest ./seafile.nix { };
  searx = runTest ./searx.nix;
  seatd = handleTest ./seatd.nix { };
  send = runTest ./send.nix;
  service-runner = handleTest ./service-runner.nix { };
  servo = runTest ./servo.nix;
  sftpgo = runTest ./sftpgo.nix;
  sfxr-qt = handleTest ./sfxr-qt.nix { };
  sgt-puzzles = handleTest ./sgt-puzzles.nix { };
  shadow = handleTest ./shadow.nix { };
  shadowsocks = handleTest ./shadowsocks { };
  shadps4 = runTest ./shadps4.nix;
  shattered-pixel-dungeon = handleTest ./shattered-pixel-dungeon.nix { };
  shiori = handleTest ./shiori.nix { };
  signal-desktop = runTest ./signal-desktop.nix;
  silverbullet = handleTest ./silverbullet.nix { };
  simple = handleTest ./simple.nix { };
  sing-box = handleTest ./sing-box.nix { };
  slimserver = handleTest ./slimserver.nix { };
  slurm = handleTest ./slurm.nix { };
  smokeping = handleTest ./smokeping.nix { };
  snapcast = runTest ./snapcast.nix;
  snapper = handleTest ./snapper.nix { };
  snipe-it = runTest ./web-apps/snipe-it.nix;
  snmpd = handleTest ./snmpd.nix { };
  soapui = handleTest ./soapui.nix { };
  soft-serve = handleTest ./soft-serve.nix { };
  sogo = handleTest ./sogo.nix { };
  soju = handleTest ./soju.nix { };
  solanum = handleTest ./solanum.nix { };
  sonarr = handleTest ./sonarr.nix { };
  sonic-server = handleTest ./sonic-server.nix { };
  sourcehut = handleTest ./sourcehut { };
  spacecookie = handleTest ./spacecookie.nix { };
  spark = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./spark { };
  spiped = runTest ./spiped.nix;
  sqlite3-to-mysql = handleTest ./sqlite3-to-mysql.nix { };
  squid = handleTest ./squid.nix { };
  ssh-agent-auth = handleTest ./ssh-agent-auth.nix { };
  ssh-audit = handleTest ./ssh-audit.nix { };
  sslh = handleTest ./sslh.nix { };
  sssd = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd.nix { };
  sssd-ldap = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd-ldap.nix { };
  stalwart-mail = handleTest ./stalwart-mail.nix { };
  stargazer = runTest ./web-servers/stargazer.nix;
  starship = runTest ./starship.nix;
  startx = import ./startx.nix { inherit pkgs runTest; };
  stash = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stash.nix { };
  static-web-server = runTest ./web-servers/static-web-server.nix;
  step-ca = handleTestOn [ "x86_64-linux" ] ./step-ca.nix { };
  stratis = handleTest ./stratis { };
  strongswan-swanctl = handleTest ./strongswan-swanctl.nix { };
  stub-ld = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stub-ld.nix { };
  stunnel = handleTest ./stunnel.nix { };
  sudo = handleTest ./sudo.nix { };
  sudo-rs = runTest ./sudo-rs.nix;
  sunshine = runTest ./sunshine.nix;
  suricata = handleTest ./suricata.nix { };
  suwayomi-server = handleTest ./suwayomi-server.nix { };
  swap-file-btrfs = handleTest ./swap-file-btrfs.nix { };
  swap-partition = handleTest ./swap-partition.nix { };
  swap-random-encryption = handleTest ./swap-random-encryption.nix { };
  swapspace = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./swapspace.nix { };
  sway = handleTest ./sway.nix { };
  swayfx = handleTest ./swayfx.nix { };
  switchTest = runTest {
    imports = [ ./switch-test.nix ];
    defaults.system.switch.enableNg = false;
  };
  switchTestNg = runTest {
    imports = [ ./switch-test.nix ];
    defaults.system.switch.enableNg = true;
  };
  sx = handleTest ./sx.nix { };
  sympa = handleTest ./sympa.nix { };
  syncthing = handleTest ./syncthing.nix { };
  syncthing-folders = runTest ./syncthing-folders.nix;
  syncthing-init = handleTest ./syncthing-init.nix { };
  syncthing-many-devices = handleTest ./syncthing-many-devices.nix { };
  syncthing-no-settings = handleTest ./syncthing-no-settings.nix { };
  syncthing-relay = handleTest ./syncthing-relay.nix { };
  sysinit-reactivation = runTest ./sysinit-reactivation.nix;
  systemd = handleTest ./systemd.nix { };
  systemd-analyze = handleTest ./systemd-analyze.nix { };
  systemd-binfmt = handleTestOn [ "x86_64-linux" ] ./systemd-binfmt.nix { };
  systemd-boot = handleTest ./systemd-boot.nix { };
  systemd-bpf = handleTest ./systemd-bpf.nix { };
  systemd-confinement = handleTest ./systemd-confinement { };
  systemd-coredump = handleTest ./systemd-coredump.nix { };
  systemd-credentials-tpm2 = handleTest ./systemd-credentials-tpm2.nix { };
  systemd-cryptenroll = handleTest ./systemd-cryptenroll.nix { };
  systemd-escaping = handleTest ./systemd-escaping.nix { };
  systemd-homed = handleTest ./systemd-homed.nix { };
  systemd-initrd-bridge = handleTest ./systemd-initrd-bridge.nix { };
  systemd-initrd-btrfs-raid = handleTest ./systemd-initrd-btrfs-raid.nix { };
  systemd-initrd-credentials = handleTest ./systemd-initrd-credentials.nix { };
  systemd-initrd-luks-empty-passphrase = handleTest ./initrd-luks-empty-passphrase.nix {
    systemdStage1 = true;
  };
  systemd-initrd-luks-fido2 = handleTest ./systemd-initrd-luks-fido2.nix { };
  systemd-initrd-luks-keyfile = handleTest ./systemd-initrd-luks-keyfile.nix { };
  systemd-initrd-luks-password = handleTest ./systemd-initrd-luks-password.nix { };
  systemd-initrd-luks-tpm2 = handleTest ./systemd-initrd-luks-tpm2.nix { };
  systemd-initrd-luks-unl0kr = handleTest ./systemd-initrd-luks-unl0kr.nix { };
  systemd-initrd-modprobe = handleTest ./systemd-initrd-modprobe.nix { };
  systemd-initrd-networkd = handleTest ./systemd-initrd-networkd.nix { };
  systemd-initrd-networkd-openvpn = handleTestOn [
    "x86_64-linux"
    "i686-linux"
  ] ./initrd-network-openvpn { systemdStage1 = true; };
  systemd-initrd-networkd-ssh = handleTest ./systemd-initrd-networkd-ssh.nix { };
  systemd-initrd-shutdown = handleTest ./systemd-shutdown.nix { systemdStage1 = true; };
  systemd-initrd-simple = runTest ./systemd-initrd-simple.nix;
  systemd-initrd-swraid = handleTest ./systemd-initrd-swraid.nix { };
  systemd-initrd-vconsole = handleTest ./systemd-initrd-vconsole.nix { };
  systemd-initrd-vlan = handleTest ./systemd-initrd-vlan.nix { };
  systemd-journal = handleTest ./systemd-journal.nix { };
  systemd-journal-gateway = handleTest ./systemd-journal-gateway.nix { };
  systemd-journal-upload = handleTest ./systemd-journal-upload.nix { };
  systemd-lock-handler = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./systemd-lock-handler.nix;
  systemd-machinectl = handleTest ./systemd-machinectl.nix { };
  systemd-misc = handleTest ./systemd-misc.nix { };
  systemd-networkd = handleTest ./systemd-networkd.nix { };
  systemd-networkd-bridge = handleTest ./systemd-networkd-bridge.nix { };
  systemd-networkd-dhcpserver = handleTest ./systemd-networkd-dhcpserver.nix { };
  systemd-networkd-dhcpserver-static-leases =
    handleTest ./systemd-networkd-dhcpserver-static-leases.nix
      { };
  systemd-networkd-ipv6-prefix-delegation =
    handleTest ./systemd-networkd-ipv6-prefix-delegation.nix
      { };
  systemd-networkd-vrf = handleTest ./systemd-networkd-vrf.nix { };
  systemd-no-tainted = handleTest ./systemd-no-tainted.nix { };
  systemd-nspawn = handleTest ./systemd-nspawn.nix { };
  systemd-nspawn-configfile = handleTest ./systemd-nspawn-configfile.nix { };
  systemd-oomd = handleTest ./systemd-oomd.nix { };
  systemd-portabled = handleTest ./systemd-portabled.nix { };
  systemd-repart = handleTest ./systemd-repart.nix { };
  systemd-resolved = handleTest ./systemd-resolved.nix { };
  systemd-shutdown = handleTest ./systemd-shutdown.nix { };
  systemd-ssh-proxy = runTest ./systemd-ssh-proxy.nix;
  systemd-sysupdate = runTest ./systemd-sysupdate.nix;
  systemd-sysusers-immutable = runTest ./systemd-sysusers-immutable.nix;
  systemd-sysusers-mutable = runTest ./systemd-sysusers-mutable.nix;
  systemd-sysusers-password-option-override-ordering = runTest ./systemd-sysusers-password-option-override-ordering.nix;
  systemd-timesyncd = handleTest ./systemd-timesyncd.nix { };
  systemd-timesyncd-nscd-dnssec = handleTest ./systemd-timesyncd-nscd-dnssec.nix { };
  systemd-user-linger = handleTest ./systemd-user-linger.nix { };
  systemd-user-tmpfiles-rules = handleTest ./systemd-user-tmpfiles-rules.nix { };
  systemd-userdbd = handleTest ./systemd-userdbd.nix { };
  systemtap = handleTest ./systemtap.nix { };
  taler = handleTest ./taler { };
  tandoor-recipes = handleTest ./tandoor-recipes.nix { };
  tandoor-recipes-script-name = handleTest ./tandoor-recipes-script-name.nix { };
  tang = handleTest ./tang.nix { };
  taskchampion-sync-server = handleTest ./taskchampion-sync-server.nix { };
  taskserver = handleTest ./taskserver.nix { };
  tayga = handleTest ./tayga.nix { };
  technitium-dns-server = handleTest ./technitium-dns-server.nix { };
  teeworlds = handleTest ./teeworlds.nix { };
  telegraf = runTest ./telegraf.nix;
  teleport = handleTest ./teleport.nix { };
  teleports = runTest ./teleports.nix;
  terminal-emulators = handleTest ./terminal-emulators.nix { };
  thanos = handleTest ./thanos.nix { };
  thelounge = handleTest ./thelounge.nix { };
  tiddlywiki = handleTest ./tiddlywiki.nix { };
  tigervnc = handleTest ./tigervnc.nix { };
  tika = runTest ./tika.nix;
  timezone = handleTest ./timezone.nix { };
  timidity = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./timidity { };
  tinc = handleTest ./tinc { };
  tinydns = handleTest ./tinydns.nix { };
  tinyproxy = handleTest ./tinyproxy.nix { };
  tinywl = handleTest ./tinywl.nix { };
  tlsrpt = runTest ./tlsrpt.nix;
  tmate-ssh-server = handleTest ./tmate-ssh-server.nix { };
  tomcat = handleTest ./tomcat.nix { };
  tor = handleTest ./tor.nix { };
  tpm-ek = handleTest ./tpm-ek { };
  # tracee requires bpf
  tracee = handleTestOn [ "x86_64-linux" ] ./tracee.nix { };
  traefik = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./traefik.nix;
  trafficserver = handleTest ./trafficserver.nix { };
  transfer-sh = handleTest ./transfer-sh.nix { };
  transmission_3 = handleTest ./transmission.nix { transmission = pkgs.transmission_3; };
  transmission_4 = handleTest ./transmission.nix { transmission = pkgs.transmission_4; };
  trezord = handleTest ./trezord.nix { };
  trickster = handleTest ./trickster.nix { };
  trilium-server = handleTestOn [ "x86_64-linux" ] ./trilium-server.nix { };
  tsm-client-gui = handleTest ./tsm-client-gui.nix { };
  tt-rss = handleTest ./web-apps/tt-rss.nix { };
  ttyd = handleTest ./web-servers/ttyd.nix { };
  tuned = runTest ./tuned.nix;
  tuptime = handleTest ./tuptime.nix { };
  turbovnc-headless-server = handleTest ./turbovnc-headless-server.nix { };
  turn-rs = handleTest ./turn-rs.nix { };
  tusd = runTest ./tusd/default.nix;
  tuxguitar = runTest ./tuxguitar.nix;
  twingate = runTest ./twingate.nix;
  txredisapi = handleTest ./txredisapi.nix { };
  typesense = handleTest ./typesense.nix { };
  tzupdate = runTest ./tzupdate.nix;
  ucarp = handleTest ./ucarp.nix { };
  udisks2 = handleTest ./udisks2.nix { };
  ulogd = handleTest ./ulogd/ulogd.nix { };
  umurmur = handleTest ./umurmur.nix { };
  unbound = handleTest ./unbound.nix { };
  unifi = runTest ./unifi.nix;
  unit-perl = handleTest ./web-servers/unit-perl.nix { };
  unit-php = runTest ./web-servers/unit-php.nix;
  upnp.iptables = handleTest ./upnp.nix { useNftables = false; };
  upnp.nftables = handleTest ./upnp.nix { useNftables = true; };
  uptermd = handleTest ./uptermd.nix { };
  uptime-kuma = handleTest ./uptime-kuma.nix { };
  urn-timer = handleTest ./urn-timer.nix { };
  usbguard = handleTest ./usbguard.nix { };
  user-activation-scripts = handleTest ./user-activation-scripts.nix { };
  user-enable-option = runTest ./user-enable-option.nix;
  user-expiry = runTest ./user-expiry.nix;
  user-home-mode = handleTest ./user-home-mode.nix { };
  userborn = runTest ./userborn.nix;
  userborn-immutable-etc = runTest ./userborn-immutable-etc.nix;
  userborn-immutable-users = runTest ./userborn-immutable-users.nix;
  userborn-mutable-etc = runTest ./userborn-mutable-etc.nix;
  userborn-mutable-users = runTest ./userborn-mutable-users.nix;
  ustreamer = handleTest ./ustreamer.nix { };
  uwsgi = handleTest ./uwsgi.nix { };
  v2ray = handleTest ./v2ray.nix { };
  varnish60 = runTest {
    imports = [ ./varnish.nix ];
    _module.args.package = pkgs.varnish60;
  };
  varnish77 = runTest {
    imports = [ ./varnish.nix ];
    _module.args.package = pkgs.varnish77;
  };
  vault = handleTest ./vault.nix { };
  vault-agent = handleTest ./vault-agent.nix { };
  vault-dev = handleTest ./vault-dev.nix { };
  vault-postgresql = handleTest ./vault-postgresql.nix { };
  vaultwarden = discoverTests (import ./vaultwarden.nix);
  vdirsyncer = handleTest ./vdirsyncer.nix { };
  vector = handleTest ./vector { };
  velocity = runTest ./velocity.nix;
  vengi-tools = handleTest ./vengi-tools.nix { };
  victorialogs = runTest ./victorialogs.nix;
  victoriametrics = handleTest ./victoriametrics { };
  vikunja = handleTest ./vikunja.nix { };
  virtualbox = handleTestOn [ "x86_64-linux" ] ./virtualbox.nix { };
  vm-variant = handleTest ./vm-variant.nix { };
  vscode-remote-ssh = handleTestOn [ "x86_64-linux" ] ./vscode-remote-ssh.nix { };
  vscodium = discoverTests (import ./vscodium.nix);
  vsftpd = handleTest ./vsftpd.nix { };
  waagent = handleTest ./waagent.nix { };
  wakapi = runTest ./wakapi.nix;
  warzone2100 = handleTest ./warzone2100.nix { };
  wasabibackend = handleTest ./wasabibackend.nix { };
  wastebin = runTest ./wastebin.nix;
  watchdogd = handleTest ./watchdogd.nix { };
  webhook = runTest ./webhook.nix;
  weblate = handleTest ./web-apps/weblate.nix { };
  wg-access-server = handleTest ./wg-access-server.nix { };
  whisparr = handleTest ./whisparr.nix { };
  whoami = runTest ./whoami.nix;
  whoogle-search = handleTest ./whoogle-search.nix { };
  wiki-js = runTest ./wiki-js.nix;
  wine = handleTest ./wine.nix { };
  wireguard = handleTest ./wireguard { };
  without-nix = handleTest ./without-nix.nix { };
  wmderland = handleTest ./wmderland.nix { };
  wordpress = runTest ./wordpress.nix;
  workout-tracker = handleTest ./workout-tracker.nix { };
  wpa_supplicant = import ./wpa_supplicant.nix { inherit pkgs runTest; };
  wrappers = handleTest ./wrappers.nix { };
  writefreely = import ./web-apps/writefreely.nix { inherit pkgs runTest; };
  wstunnel = runTest ./wstunnel.nix;
  xandikos = runTest ./xandikos.nix;
  xautolock = runTest ./xautolock.nix;
  xfce = runTest ./xfce.nix;
  xfce-wayland = runTest ./xfce-wayland.nix;
  xmonad = runTest ./xmonad.nix;
  xmonad-xdg-autostart = runTest ./xmonad-xdg-autostart.nix;
  xpadneo = runTest ./xpadneo.nix;
  xrdp = runTest ./xrdp.nix;
  xrdp-with-audio-pulseaudio = runTest ./xrdp-with-audio-pulseaudio.nix;
  xscreensaver = runTest ./xscreensaver.nix;
  xss-lock = runTest ./xss-lock.nix;
  xterm = runTest ./xterm.nix;
  xxh = runTest ./xxh.nix;
  yarr = runTest ./yarr.nix;
  ydotool = handleTest ./ydotool.nix { };
  yggdrasil = runTest ./yggdrasil.nix;
  your_spotify = runTest ./your_spotify.nix;
  zammad = runTest ./zammad.nix;
  zenohd = runTest ./zenohd.nix;
  zeronet-conservancy = runTest ./zeronet-conservancy.nix;
  zfs = handleTest ./zfs.nix { };
  zigbee2mqtt_1 = runTest {
    imports = [ ./zigbee2mqtt.nix ];
    _module.args.package = pkgs.zigbee2mqtt_1;
  };
  zigbee2mqtt_2 = runTest {
    imports = [ ./zigbee2mqtt.nix ];
    _module.args.package = pkgs.zigbee2mqtt_2;
  };
  zipline = runTest ./zipline.nix;
  zoneminder = runTest ./zoneminder.nix;
  zookeeper = runTest ./zookeeper.nix;
  zoom-us = runTest ./zoom-us.nix;
  zram-generator = runTest ./zram-generator.nix;
  zrepl = runTest ./zrepl.nix;
  zsh-history = runTest ./zsh-history.nix;
  zwave-js = runTest ./zwave-js.nix;
  zwave-js-ui = runTest ./zwave-js-ui.nix;
  # keep-sorted end
}
