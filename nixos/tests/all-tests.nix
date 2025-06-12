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
    extra-python-packages = runTest ./nixos-test-driver/extra-python-packages.nix;
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

  _3proxy = runTest ./3proxy.nix;
  aaaaxy = runTest ./aaaaxy.nix;
  acme = import ./acme/default.nix { inherit runTest; };
  acme-dns = runTest ./acme-dns.nix;
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
  appliance-repart-image = runTest ./appliance-repart-image.nix;
  appliance-repart-image-verity-store = runTest ./appliance-repart-image-verity-store.nix;
  apparmor = runTest ./apparmor;
  archi = runTest ./archi.nix;
  aria2 = runTest ./aria2.nix;
  armagetronad = runTest ./armagetronad.nix;
  artalk = runTest ./artalk.nix;
  atd = runTest ./atd.nix;
  atop = import ./atop.nix { inherit pkgs runTest; };
  atticd = runTest ./atticd.nix;
  atuin = runTest ./atuin.nix;
  ax25 = runTest ./ax25.nix;
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
  ayatana-indicators = runTest ./ayatana-indicators.nix;
  babeld = runTest ./babeld.nix;
  bazarr = runTest ./bazarr.nix;
  bcachefs = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./bcachefs.nix;
  beanstalkd = runTest ./beanstalkd.nix;
  bees = runTest ./bees.nix;
  benchexec = runTest ./benchexec.nix;
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
  bitcoind = runTest ./bitcoind.nix;
  bittorrent = runTest ./bittorrent.nix;
  blockbook-frontend = runTest ./blockbook-frontend.nix;
  blocky = handleTest ./blocky.nix { };
  boot = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./boot.nix { };
  bootspec = handleTestOn [ "x86_64-linux" ] ./bootspec.nix { };
  boot-stage1 = runTest ./boot-stage1.nix;
  boot-stage2 = runTest ./boot-stage2.nix;
  borgbackup = runTest ./borgbackup.nix;
  borgmatic = runTest ./borgmatic.nix;
  botamusique = runTest ./botamusique.nix;
  bpf = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./bpf.nix { };
  bpftune = runTest ./bpftune.nix;
  breitbandmessung = runTest ./breitbandmessung.nix;
  broadcast-box = runTest ./broadcast-box.nix;
  brscan5 = runTest ./brscan5.nix;
  btrbk = runTest ./btrbk.nix;
  btrbk-doas = runTest ./btrbk-doas.nix;
  btrbk-no-timer = runTest ./btrbk-no-timer.nix;
  btrbk-section-order = runTest ./btrbk-section-order.nix;
  budgie = runTest ./budgie.nix;
  buildbot = runTest ./buildbot.nix;
  buildkite-agents = runTest ./buildkite-agents.nix;
  c2fmzq = runTest ./c2fmzq.nix;
  caddy = runTest ./caddy.nix;
  cadvisor = handleTestOn [ "x86_64-linux" ] ./cadvisor.nix { };
  cage = runTest ./cage.nix;
  cagebreak = runTest ./cagebreak.nix;
  calibre-web = runTest ./calibre-web.nix;
  calibre-server = import ./calibre-server.nix { inherit pkgs runTest; };
  canaille = runTest ./canaille.nix;
  castopod = runTest ./castopod.nix;
  cassandra_4 = handleTest ./cassandra.nix { testPackage = pkgs.cassandra_4; };
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
  charliecloud = runTest ./charliecloud.nix;
  chromadb = runTest ./chromadb.nix;
  chromium = (handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chromium.nix { }).stable or { };
  chrony = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony.nix { };
  chrony-ptp = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony-ptp.nix { };
  cinnamon = runTest ./cinnamon.nix;
  cinnamon-wayland = runTest ./cinnamon-wayland.nix;
  cjdns = runTest ./cjdns.nix;
  clatd = runTest ./clatd.nix;
  clickhouse = runTest ./clickhouse.nix;
  cloud-init = handleTest ./cloud-init.nix { };
  cloud-init-hostname = handleTest ./cloud-init-hostname.nix { };
  cloudlog = runTest ./cloudlog.nix;
  cntr = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./cntr.nix { };
  cockpit = runTest ./cockpit.nix;
  cockroachdb = handleTestOn [ "x86_64-linux" ] ./cockroachdb.nix { };
  code-server = runTest ./code-server.nix;
  coder = runTest ./coder.nix;
  collectd = runTest ./collectd.nix;
  commafeed = runTest ./commafeed.nix;
  connman = runTest ./connman.nix;
  consul = runTest ./consul.nix;
  consul-template = runTest ./consul-template.nix;
  containers-bridge = runTest ./containers-bridge.nix;
  containers-custom-pkgs.nix = runTest ./containers-custom-pkgs.nix;
  containers-ephemeral = runTest ./containers-ephemeral.nix;
  containers-extra_veth = runTest ./containers-extra_veth.nix;
  containers-hosts = runTest ./containers-hosts.nix;
  containers-imperative = runTest ./containers-imperative.nix;
  containers-ip = runTest ./containers-ip.nix;
  containers-macvlans = runTest ./containers-macvlans.nix;
  containers-names = runTest ./containers-names.nix;
  containers-nested = runTest ./containers-nested.nix;
  containers-physical_interfaces = runTest ./containers-physical_interfaces.nix;
  containers-portforward = runTest ./containers-portforward.nix;
  containers-reloadable = runTest ./containers-reloadable.nix;
  containers-require-bind-mounts = runTest ./containers-require-bind-mounts.nix;
  containers-restart_networking = runTest ./containers-restart_networking.nix;
  containers-tmpfs = runTest ./containers-tmpfs.nix;
  containers-unified-hierarchy = runTest ./containers-unified-hierarchy.nix;
  convos = runTest ./convos.nix;
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
  cosmic-noxwayland = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic-noxwayland";
    _module.args.enableAutologin = false;
    _module.args.enableXWayland = false;
  };
  cosmic-autologin-noxwayland = runTest {
    imports = [ ./cosmic.nix ];
    _module.args.testName = "cosmic-autologin-noxwayland";
    _module.args.enableAutologin = true;
    _module.args.enableXWayland = false;
  };
  coturn = runTest ./coturn.nix;
  couchdb = runTest ./couchdb.nix;
  crabfit = runTest ./crabfit.nix;
  cri-o = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./cri-o.nix { };
  cryptpad = runTest ./cryptpad.nix;
  cups-pdf = runTest ./cups-pdf.nix;
  curl-impersonate = runTest ./curl-impersonate.nix;
  custom-ca = handleTest ./custom-ca.nix { };
  croc = runTest ./croc.nix;
  cross-seed = runTest ./cross-seed.nix;
  cyrus-imap = runTest ./cyrus-imap.nix;
  darling-dmg = runTest ./darling-dmg.nix;
  dae = runTest ./dae.nix;
  davis = runTest ./davis.nix;
  db-rest = runTest ./db-rest.nix;
  dconf = runTest ./dconf.nix;
  ddns-updater = runTest ./ddns-updater.nix;
  deconz = runTest ./deconz.nix;
  deepin = runTest ./deepin.nix;
  deluge = runTest ./deluge.nix;
  dendrite = runTest ./matrix/dendrite.nix;
  dependency-track = runTest ./dependency-track.nix;
  devpi-server = runTest ./devpi-server.nix;
  dex-oidc = runTest ./dex-oidc.nix;
  dhparams = handleTest ./dhparams.nix { };
  disable-installer-tools = runTest ./disable-installer-tools.nix;
  discourse = runTest ./discourse.nix;
  dnscrypt-proxy2 = handleTestOn [ "x86_64-linux" ] ./dnscrypt-proxy2.nix { };
  dnsdist = import ./dnsdist.nix { inherit pkgs runTest; };
  doas = runTest ./doas.nix;
  docker = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker.nix;
  docker-rootless = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker-rootless.nix;
  docker-registry = runTest ./docker-registry.nix;
  docker-tools = handleTestOn [ "x86_64-linux" ] ./docker-tools.nix { };
  docker-tools-nix-shell = runTest ./docker-tools-nix-shell.nix;
  docker-tools-cross = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./docker-tools-cross.nix;
  docker-tools-overlay = runTestOn [ "x86_64-linux" ] ./docker-tools-overlay.nix;
  docling-serve = runTest ./docling-serve.nix;
  documize = runTest ./documize.nix;
  documentation = pkgs.callPackage ../modules/misc/documentation/test.nix { inherit nixosLib; };
  doh-proxy-rust = runTest ./doh-proxy-rust.nix;
  dokuwiki = runTest ./dokuwiki.nix;
  dolibarr = runTest ./dolibarr.nix;
  domination = runTest ./domination.nix;
  dovecot = handleTest ./dovecot.nix { };
  drawterm = discoverTests (import ./drawterm.nix);
  draupnir = runTest ./matrix/draupnir.nix;
  drbd = runTest ./drbd.nix;
  druid = handleTestOn [ "x86_64-linux" ] ./druid { };
  drupal = runTest ./drupal.nix;
  drbd-driver = runTest ./drbd-driver.nix;
  dublin-traceroute = runTest ./dublin-traceroute.nix;
  dwl = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./dwl.nix;
  earlyoom = handleTestOn [ "x86_64-linux" ] ./earlyoom.nix { };
  early-mount-options = handleTest ./early-mount-options.nix { };
  ec2-config = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-config or { };
  ec2-nixops = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-nixops or { };
  echoip = runTest ./echoip.nix;
  ecryptfs = runTest ./ecryptfs.nix;
  fscrypt = runTest ./fscrypt.nix;
  fastnetmon-advanced = runTest ./fastnetmon-advanced.nix;
  lauti = runTest ./lauti.nix;
  ejabberd = runTest ./xmpp/ejabberd.nix;
  elk = handleTestOn [ "x86_64-linux" ] ./elk.nix { };
  emacs-daemon = runTest ./emacs-daemon.nix;
  endlessh = runTest ./endlessh.nix;
  endlessh-go = runTest ./endlessh-go.nix;
  engelsystem = runTest ./engelsystem.nix;
  enlightenment = runTest ./enlightenment.nix;
  env = runTest ./env.nix;
  envfs = runTest ./envfs.nix;
  envoy = runTest {
    imports = [ ./envoy.nix ];
    _module.args.envoyPackage = pkgs.envoy;
  };
  envoy-bin = runTest {
    imports = [ ./envoy.nix ];
    _module.args.envoyPackage = pkgs.envoy-bin;
  };
  ergo = runTest ./ergo.nix;
  ergochat = runTest ./ergochat.nix;
  eris-server = runTest ./eris-server.nix;
  esphome = runTest ./esphome.nix;
  etc = pkgs.callPackage ../modules/system/etc/test.nix { inherit evalMinimalConfig; };
  activation = pkgs.callPackage ../modules/system/activation/test.nix { };
  activation-lib = pkgs.callPackage ../modules/system/activation/lib/test.nix { };
  activation-var = runTest ./activation/var.nix;
  activation-nix-channel = runTest ./activation/nix-channel.nix;
  activation-etc-overlay-mutable = runTest ./activation/etc-overlay-mutable.nix;
  activation-etc-overlay-immutable = runTest ./activation/etc-overlay-immutable.nix;
  activation-perlless = runTest ./activation/perlless.nix;
  etcd = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./etcd/etcd.nix { };
  etcd-cluster = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./etcd/etcd-cluster.nix { };
  etebase-server = runTest ./etebase-server.nix;
  etesync-dav = runTest ./etesync-dav.nix;
  evcc = runTest ./evcc.nix;
  fail2ban = runTest ./fail2ban.nix;
  fakeroute = runTest ./fakeroute.nix;
  fancontrol = runTest ./fancontrol.nix;
  fanout = runTest ./fanout.nix;
  fcitx5 = handleTest ./fcitx5 { };
  fedimintd = runTest ./fedimintd.nix;
  fenics = runTest ./fenics.nix;
  ferm = runTest ./ferm.nix;
  ferretdb = handleTest ./ferretdb.nix { };
  fider = runTest ./fider.nix;
  filesender = runTest ./filesender.nix;
  filebrowser = runTest ./filebrowser.nix;
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
  firefox-esr-128 = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-esr-128;
  };
  firefoxpwa = runTest ./firefoxpwa.nix;
  firejail = runTest ./firejail.nix;
  firewall = handleTest ./firewall.nix { nftables = false; };
  firewall-nftables = handleTest ./firewall.nix { nftables = true; };
  fish = runTest ./fish.nix;
  firezone = runTest ./firezone/firezone.nix;
  flannel = handleTestOn [ "x86_64-linux" ] ./flannel.nix { };
  flaresolverr = runTest ./flaresolverr.nix;
  flood = runTest ./flood.nix;
  floorp = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.floorp;
  };
  fluent-bit = runTest ./fluent-bit.nix;
  fluentd = runTest ./fluentd.nix;
  fluidd = runTest ./fluidd.nix;
  fontconfig-default-fonts = runTest ./fontconfig-default-fonts.nix;
  forgejo = import ./forgejo.nix {
    inherit runTest;
    forgejoPackage = pkgs.forgejo;
  };
  forgejo-lts = import ./forgejo.nix {
    inherit runTest;
    forgejoPackage = pkgs.forgejo-lts;
  };
  freenet = runTest ./freenet.nix;
  freeswitch = runTest ./freeswitch.nix;
  freetube = discoverTests (import ./freetube.nix);
  freshrss = handleTest ./freshrss { };
  frigate = runTest ./frigate.nix;
  froide-govplan = runTest ./web-apps/froide-govplan.nix;
  frp = runTest ./frp.nix;
  frr = runTest ./frr.nix;
  fsck = handleTest ./fsck.nix { };
  fsck-systemd-stage-1 = handleTest ./fsck.nix { systemdStage1 = true; };
  ft2-clone = runTest ./ft2-clone.nix;
  legit = runTest ./legit.nix;
  mimir = runTest ./mimir.nix;
  galene = discoverTests (import ./galene.nix);
  gancio = runTest ./gancio.nix;
  garage = handleTest ./garage { };
  gatus = runTest ./gatus.nix;
  getaddrinfo = runTest ./getaddrinfo.nix;
  gemstash = handleTest ./gemstash.nix { };
  geoclue2 = runTest ./geoclue2.nix;
  geoserver = runTest ./geoserver.nix;
  gerrit = runTest ./gerrit.nix;
  geth = runTest ./geth.nix;
  ghostunnel = runTest ./ghostunnel.nix;
  gitdaemon = runTest ./gitdaemon.nix;
  gitea = handleTest ./gitea.nix { giteaPackage = pkgs.gitea; };
  github-runner = runTest ./github-runner.nix;
  gitlab = runTest ./gitlab.nix;
  gitolite = runTest ./gitolite.nix;
  gitolite-fcgiwrap = runTest ./gitolite-fcgiwrap.nix;
  glance = runTest ./glance.nix;
  glances = runTest ./glances.nix;
  glitchtip = runTest ./glitchtip.nix;
  glusterfs = runTest ./glusterfs.nix;
  gnome = runTest ./gnome.nix;
  gnome-extensions = runTest ./gnome-extensions.nix;
  gnome-flashback = runTest ./gnome-flashback.nix;
  gnome-xorg = runTest ./gnome-xorg.nix;
  gns3-server = runTest ./gns3-server.nix;
  gnupg = runTest ./gnupg.nix;
  goatcounter = runTest ./goatcounter.nix;
  go-camo = handleTest ./go-camo.nix { };
  go-neb = runTest ./go-neb.nix;
  gobgpd = runTest ./gobgpd.nix;
  gocd-agent = runTest ./gocd-agent.nix;
  gocd-server = runTest ./gocd-server.nix;
  gokapi = runTest ./gokapi.nix;
  gollum = runTest ./gollum.nix;
  gonic = runTest ./gonic.nix;
  google-oslogin = handleTest ./google-oslogin { };
  gopro-tool = runTest ./gopro-tool.nix;
  goss = runTest ./goss.nix;
  gotenberg = runTest ./gotenberg.nix;
  gotify-server = runTest ./gotify-server.nix;
  gotosocial = runTest ./web-apps/gotosocial.nix;
  grafana = handleTest ./grafana { };
  graphite = runTest ./graphite.nix;
  grav = runTest ./web-apps/grav.nix;
  graylog = runTest ./graylog.nix;
  greetd-no-shadow = runTest ./greetd-no-shadow.nix;
  grocy = runTest ./grocy.nix;
  grow-partition = runTest ./grow-partition.nix;
  grub = runTest ./grub.nix;
  guacamole-server = runTest ./guacamole-server.nix;
  guix = handleTest ./guix { };
  gvisor = runTest ./gvisor.nix;
  h2o = import ./web-servers/h2o { inherit recurseIntoAttrs runTest; };
  hadoop = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop;
  };
  hadoop_3_3 = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop_3_3;
  };
  hadoop2 = import ./hadoop {
    inherit handleTestOn;
    package = pkgs.hadoop2;
  };
  haste-server = runTest ./haste-server.nix;
  haproxy = runTest ./haproxy.nix;
  hardened = runTest ./hardened.nix;
  harmonia = runTest ./harmonia.nix;
  headscale = runTest ./headscale.nix;
  healthchecks = runTest ./web-apps/healthchecks.nix;
  hbase2 = handleTest ./hbase.nix { package = pkgs.hbase2; };
  hbase_2_5 = handleTest ./hbase.nix { package = pkgs.hbase_2_5; };
  hbase_2_4 = handleTest ./hbase.nix { package = pkgs.hbase_2_4; };
  hbase3 = handleTest ./hbase.nix { package = pkgs.hbase3; };
  hedgedoc = runTest ./hedgedoc.nix;
  herbstluftwm = runTest ./herbstluftwm.nix;
  homebox = runTest ./homebox.nix;
  homer = handleTest ./homer { };
  homepage-dashboard = runTest ./homepage-dashboard.nix;
  honk = runTest ./honk.nix;
  installed-tests = pkgs.recurseIntoAttrs (handleTest ./installed-tests { });
  invidious = runTest ./invidious.nix;
  iosched = runTest ./iosched.nix;
  isolate = runTest ./isolate.nix;
  livebook-service = runTest ./livebook-service.nix;
  pyload = runTest ./pyload.nix;
  oci-containers = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./oci-containers.nix { };
  odoo = runTest ./odoo.nix;
  odoo17 = runTest {
    imports = [ ./odoo.nix ];
    _module.args.package = pkgs.odoo17;
  };
  odoo16 = runTest {
    imports = [ ./odoo.nix ];
    _module.args.package = pkgs.odoo16;
  };
  oncall = runTest ./web-apps/oncall.nix;
  # 9pnet_virtio used to mount /nix partition doesn't support
  # hibernation. This test happens to work on x86_64-linux but
  # not on other platforms.
  hibernate = handleTestOn [ "x86_64-linux" ] ./hibernate.nix { };
  hibernate-systemd-stage-1 = handleTestOn [ "x86_64-linux" ] ./hibernate.nix {
    systemdStage1 = true;
  };
  hitch = handleTest ./hitch { };
  hledger-web = runTest ./hledger-web.nix;
  hockeypuck = runTest ./hockeypuck.nix;
  home-assistant = runTest ./home-assistant.nix;
  hostname = handleTest ./hostname.nix { };
  hound = runTest ./hound.nix;
  hub = runTest ./git/hub.nix;
  hydra = runTest ./hydra;
  i3wm = runTest ./i3wm.nix;
  icingaweb2 = runTest ./icingaweb2.nix;
  ifm = runTest ./ifm.nix;
  iftop = runTest ./iftop.nix;
  immich = runTest ./web-apps/immich.nix;
  immich-public-proxy = runTest ./web-apps/immich-public-proxy.nix;
  incron = runTest ./incron.nix;
  incus = pkgs.recurseIntoAttrs (
    handleTest ./incus {
      lts = false;
      inherit system pkgs;
    }
  );
  incus-lts = pkgs.recurseIntoAttrs (handleTest ./incus { inherit system pkgs; });
  influxdb = runTest ./influxdb.nix;
  influxdb2 = runTest ./influxdb2.nix;
  initrd-luks-empty-passphrase = runTest ./initrd-luks-empty-passphrase.nix;
  initrd-network-openvpn = handleTestOn [ "x86_64-linux" "i686-linux" ] ./initrd-network-openvpn { };
  initrd-network-ssh = handleTest ./initrd-network-ssh { };
  initrd-secrets = handleTest ./initrd-secrets.nix { };
  initrd-secrets-changing = handleTest ./initrd-secrets-changing.nix { };
  initrdNetwork = runTest ./initrd-network.nix;
  input-remapper = runTest ./input-remapper.nix;
  inspircd = runTest ./inspircd.nix;
  installer = handleTest ./installer.nix { };
  installer-systemd-stage-1 = handleTest ./installer-systemd-stage-1.nix { };
  intune = runTest ./intune.nix;
  invoiceplane = runTest ./invoiceplane.nix;
  iodine = runTest ./iodine.nix;
  ipv6 = runTest ./ipv6.nix;
  iscsi-multipath-root = runTest ./iscsi-multipath-root.nix;
  iscsi-root = runTest ./iscsi-root.nix;
  isso = runTest ./isso.nix;
  jackett = runTest ./jackett.nix;
  jellyfin = runTest ./jellyfin.nix;
  jenkins = runTest ./jenkins.nix;
  jenkins-cli = runTest ./jenkins-cli.nix;
  jibri = runTest ./jibri.nix;
  jirafeau = runTest ./jirafeau.nix;
  jitsi-meet = runTest ./jitsi-meet.nix;
  jool = import ./jool.nix { inherit pkgs runTest; };
  jotta-cli = runTest ./jotta-cli.nix;
  k3s = handleTest ./k3s { };
  kafka = handleTest ./kafka { };
  kanboard = runTest ./web-apps/kanboard.nix;
  kanidm = runTest ./kanidm.nix;
  kanidm-provisioning = runTest ./kanidm-provisioning.nix;
  karma = runTest ./karma.nix;
  kavita = runTest ./kavita.nix;
  kbd-setfont-decompress = runTest ./kbd-setfont-decompress.nix;
  kbd-update-search-paths-patch = runTest ./kbd-update-search-paths-patch.nix;
  kea = runTest ./kea.nix;
  keepalived = runTest ./keepalived.nix;
  keepassxc = runTest ./keepassxc.nix;
  kerberos = handleTest ./kerberos/default.nix { };
  kernel-generic = handleTest ./kernel-generic.nix { };
  kernel-latest-ath-user-regd = runTest ./kernel-latest-ath-user-regd.nix;
  kernel-rust = handleTest ./kernel-rust.nix { };
  keter = runTest ./keter.nix;
  kexec = runTest ./kexec.nix;
  keycloak = discoverTests (import ./keycloak.nix);
  keyd = handleTest ./keyd.nix { };
  keymap = handleTest ./keymap.nix { };
  kimai = runTest ./kimai.nix;
  kismet = runTest ./kismet.nix;
  kmonad = runTest ./kmonad.nix;
  knot = runTest ./knot.nix;
  komga = runTest ./komga.nix;
  krb5 = discoverTests (import ./krb5);
  ksm = runTest ./ksm.nix;
  kthxbye = runTest ./kthxbye.nix;
  kubernetes = handleTestOn [ "x86_64-linux" ] ./kubernetes { };
  kubo = import ./kubo { inherit recurseIntoAttrs runTest; };
  lact = runTest ./lact.nix;
  ladybird = runTest ./ladybird.nix;
  languagetool = runTest ./languagetool.nix;
  lanraragi = runTest ./lanraragi.nix;
  latestKernel.login = runTest {
    imports = [ ./login.nix ];
    _module.args.latestKernel = true;
  };
  lasuite-docs = runTest ./web-apps/lasuite-docs.nix;
  lavalink = runTest ./lavalink.nix;
  leaps = runTest ./leaps.nix;
  lemmy = runTest ./lemmy.nix;
  libinput = runTest ./libinput.nix;
  librenms = runTest ./librenms.nix;
  libresprite = runTest ./libresprite.nix;
  libreswan = runTest ./libreswan.nix;
  libreswan-nat = runTest ./libreswan-nat.nix;
  librewolf = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.librewolf;
  };
  libuiohook = runTest ./libuiohook.nix;
  libvirtd = runTest ./libvirtd.nix;
  lidarr = runTest ./lidarr.nix;
  lightdm = runTest ./lightdm.nix;
  lighttpd = runTest ./lighttpd.nix;
  livekit = runTest ./networking/livekit.nix;
  limesurvey = runTest ./limesurvey.nix;
  limine = import ./limine { inherit runTest; };
  listmonk = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./listmonk.nix { };
  litellm = runTest ./litellm.nix;
  litestream = runTest ./litestream.nix;
  lk-jwt-service = runTest ./matrix/lk-jwt-service.nix;
  lldap = runTest ./lldap.nix;
  localsend = runTest ./localsend.nix;
  locate = runTest ./locate.nix;
  login = runTest ./login.nix;
  logrotate = runTest ./logrotate.nix;
  loki = runTest ./loki.nix;
  luks = runTest ./luks.nix;
  lvm2 = handleTest ./lvm2 { };
  lxc = handleTest ./lxc { };
  lxd = pkgs.recurseIntoAttrs (handleTest ./lxd { inherit handleTestOn; });
  lxd-image-server = runTest ./lxd-image-server.nix;
  #logstash = handleTest ./logstash.nix {};
  lomiri = discoverTests (import ./lomiri.nix);
  lomiri-calculator-app = runTest ./lomiri-calculator-app.nix;
  lomiri-calendar-app = runTest ./lomiri-calendar-app.nix;
  lomiri-camera-app = discoverTests (import ./lomiri-camera-app.nix);
  lomiri-clock-app = runTest ./lomiri-clock-app.nix;
  lomiri-docviewer-app = runTest ./lomiri-docviewer-app.nix;
  lomiri-filemanager-app = runTest ./lomiri-filemanager-app.nix;
  lomiri-mediaplayer-app = runTest ./lomiri-mediaplayer-app.nix;
  lomiri-music-app = runTest ./lomiri-music-app.nix;
  lomiri-gallery-app = discoverTests (import ./lomiri-gallery-app.nix);
  lomiri-system-settings = runTest ./lomiri-system-settings.nix;
  lorri = handleTest ./lorri/default.nix { };
  lxqt = runTest ./lxqt.nix;
  ly = runTest ./ly.nix;
  maddy = discoverTests (import ./maddy { inherit handleTest; });
  maestral = runTest ./maestral.nix;
  magic-wormhole-mailbox-server = runTest ./magic-wormhole-mailbox-server.nix;
  magnetico = runTest ./magnetico.nix;
  mailcatcher = runTest ./mailcatcher.nix;
  mailhog = runTest ./mailhog.nix;
  mailpit = runTest ./mailpit.nix;
  mailman = runTest ./mailman.nix;
  man = runTest ./man.nix;
  mariadb-galera = handleTest ./mysql/mariadb-galera.nix { };
  marytts = runTest ./marytts.nix;
  mastodon = pkgs.recurseIntoAttrs (handleTest ./web-apps/mastodon { inherit handleTestOn; });
  pixelfed = discoverTests (import ./web-apps/pixelfed { inherit handleTestOn; });
  mate = runTest ./mate.nix;
  mate-wayland = runTest ./mate-wayland.nix;
  matter-server = runTest ./matter-server.nix;
  matomo = runTest ./matomo.nix;
  matrix-alertmanager = runTest ./matrix/matrix-alertmanager.nix;
  matrix-appservice-irc = runTest ./matrix/appservice-irc.nix;
  matrix-conduit = runTest ./matrix/conduit.nix;
  matrix-continuwuity = runTest ./matrix/continuwuity.nix;
  matrix-synapse = runTest ./matrix/synapse.nix;
  matrix-synapse-workers = runTest ./matrix/synapse-workers.nix;
  mattermost = handleTest ./mattermost { };
  mautrix-meta-postgres = runTest ./matrix/mautrix-meta-postgres.nix;
  mautrix-meta-sqlite = runTest ./matrix/mautrix-meta-sqlite.nix;
  mealie = runTest ./mealie.nix;
  mediamtx = runTest ./mediamtx.nix;
  mediatomb = handleTest ./mediatomb.nix { };
  mediawiki = handleTest ./mediawiki.nix { };
  meilisearch = runTest ./meilisearch.nix;
  memcached = runTest ./memcached.nix;
  merecat = runTest ./merecat.nix;
  metabase = runTest ./metabase.nix;
  mihomo = runTest ./mihomo.nix;
  mindustry = runTest ./mindustry.nix;
  minecraft = runTest ./minecraft.nix;
  minecraft-server = runTest ./minecraft-server.nix;
  minidlna = runTest ./minidlna.nix;
  miniflux = runTest ./miniflux.nix;
  minio = runTest ./minio.nix;
  miracle-wm = runTest ./miracle-wm.nix;
  miriway = runTest ./miriway.nix;
  misc = runTest ./misc.nix;
  misskey = runTest ./misskey.nix;
  mjolnir = runTest ./matrix/mjolnir.nix;
  mobilizon = runTest ./mobilizon.nix;
  mod_perl = runTest ./mod_perl.nix;
  molly-brown = runTest ./molly-brown.nix;
  mollysocket = runTest ./mollysocket.nix;
  monado = runTest ./monado.nix;
  monetdb = runTest ./monetdb.nix;
  monica = runTest ./web-apps/monica.nix;
  mongodb = runTest ./mongodb.nix;
  mongodb-ce = runTest (
    { config, ... }:
    {
      imports = [ ./mongodb.nix ];
      defaults.services.mongodb.package = config.node.pkgs.mongodb-ce;
    }
  );
  moodle = runTest ./moodle.nix;
  moonraker = runTest ./moonraker.nix;
  mopidy = runTest ./mopidy.nix;
  morph-browser = runTest ./morph-browser.nix;
  morty = runTest ./morty.nix;
  mosquitto = runTest ./mosquitto.nix;
  moosefs = runTest ./moosefs.nix;
  movim = import ./web-apps/movim { inherit recurseIntoAttrs runTest; };
  mpd = runTest ./mpd.nix;
  mpv = runTest ./mpv.nix;
  mtp = runTest ./mtp.nix;
  multipass = runTest ./multipass.nix;
  mumble = runTest ./mumble.nix;
  # Fails on aarch64-linux at the PDF creation step - need to debug this on an
  # aarch64 machine..
  musescore = handleTestOn [ "x86_64-linux" ] ./musescore.nix { };
  music-assistant = runTest ./music-assistant.nix;
  munin = runTest ./munin.nix;
  mutableUsers = runTest ./mutable-users.nix;
  mycelium = handleTest ./mycelium { };
  mympd = runTest ./mympd.nix;
  mysql = handleTest ./mysql/mysql.nix { };
  mysql-autobackup = handleTest ./mysql/mysql-autobackup.nix { };
  mysql-backup = handleTest ./mysql/mysql-backup.nix { };
  mysql-replication = handleTest ./mysql/mysql-replication.nix { };
  n8n = runTest ./n8n.nix;
  nagios = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./nagios.nix { };
  nar-serve = runTest ./nar-serve.nix;
  nat.firewall = handleTest ./nat.nix { withFirewall = true; };
  nat.standalone = handleTest ./nat.nix { withFirewall = false; };
  nat.nftables.firewall = handleTest ./nat.nix {
    withFirewall = true;
    nftables = true;
  };
  nat.nftables.standalone = handleTest ./nat.nix {
    withFirewall = false;
    nftables = true;
  };
  nats = runTest ./nats.nix;
  navidrome = runTest ./navidrome.nix;
  nbd = runTest ./nbd.nix;
  ncdns = runTest ./ncdns.nix;
  ncps = runTest ./ncps.nix;
  ncps-custom-cache-datapath = runTest {
    imports = [ ./ncps.nix ];
    defaults.services.ncps.cache.dataPath = "/path/to/ncps";
  };
  ndppd = runTest ./ndppd.nix;
  nebula = runTest ./nebula.nix;
  neo4j = handleTest ./neo4j.nix { };
  netbird = runTest ./netbird.nix;
  netdata = runTest ./netdata.nix;
  nimdow = runTest ./nimdow.nix;
  nix-channel = pkgs.callPackage ../modules/config/nix-channel/test.nix { };
  networking.scripted = handleTest ./networking/networkd-and-scripted.nix { networkd = false; };
  networking.networkd = handleTest ./networking/networkd-and-scripted.nix { networkd = true; };
  networking.networkmanager = handleTest ./networking/networkmanager.nix { };
  netbox_3_7 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_3_7; };
  netbox_4_1 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_1; };
  netbox_4_2 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_2; };
  netbox-upgrade = runTest ./web-apps/netbox-upgrade.nix;
  # TODO: put in networking.nix after the test becomes more complete
  networkingProxy = runTest ./networking-proxy.nix;
  nextcloud = handleTest ./nextcloud { };
  nextflow = runTestOn [ "x86_64-linux" ] ./nextflow.nix;
  nextjs-ollama-llm-ui = runTest ./web-apps/nextjs-ollama-llm-ui.nix;
  nexus = runTest ./nexus.nix;
  # TODO: Test nfsv3 + Kerberos
  nfs3 = handleTest ./nfs { version = 3; };
  nfs4 = handleTest ./nfs { version = 4; };
  nghttpx = runTest ./nghttpx.nix;
  nginx = runTest ./nginx.nix;
  nginx-auth = runTest ./nginx-auth.nix;
  nginx-etag = runTest ./nginx-etag.nix;
  nginx-etag-compression = runTest ./nginx-etag-compression.nix;
  nginx-globalredirect = runTest ./nginx-globalredirect.nix;
  nginx-http3 = import ./nginx-http3.nix { inherit pkgs runTest; };
  nginx-mime = runTest ./nginx-mime.nix;
  nginx-modsecurity = runTest ./nginx-modsecurity.nix;
  nginx-moreheaders = runTest ./nginx-moreheaders.nix;
  nginx-njs = runTest ./nginx-njs.nix;
  nginx-proxyprotocol = runTest ./nginx-proxyprotocol/default.nix;
  nginx-pubhtml = runTest ./nginx-pubhtml.nix;
  nginx-redirectcode = runTest ./nginx-redirectcode.nix;
  nginx-sso = runTest ./nginx-sso.nix;
  nginx-status-page = runTest ./nginx-status-page.nix;
  nginx-tmpdir = runTest ./nginx-tmpdir.nix;
  nginx-unix-socket = runTest ./nginx-unix-socket.nix;
  nginx-variants = import ./nginx-variants.nix { inherit pkgs runTest; };
  nifi = runTestOn [ "x86_64-linux" ] ./web-apps/nifi.nix;
  nitter = runTest ./nitter.nix;
  nix-config = runTest ./nix-config.nix;
  nix-ld = runTest ./nix-ld.nix;
  nix-misc = handleTest ./nix/misc.nix { };
  nix-upgrade = handleTest ./nix/upgrade.nix { inherit (pkgs) nixVersions; };
  nix-required-mounts = runTest ./nix-required-mounts;
  nix-serve = runTest ./nix-serve.nix;
  nix-serve-ssh = runTest ./nix-serve-ssh.nix;
  nixops = handleTest ./nixops/default.nix { };
  nixos-generate-config = runTest ./nixos-generate-config.nix;
  nixos-rebuild-install-bootloader = handleTestOn [
    "x86_64-linux"
  ] ./nixos-rebuild-install-bootloader.nix { withNg = false; };
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
  nixseparatedebuginfod = runTest ./nixseparatedebuginfod.nix;
  node-red = runTest ./node-red.nix;
  nomad = runTest ./nomad.nix;
  non-default-filesystems = handleTest ./non-default-filesystems.nix { };
  non-switchable-system = runTest ./non-switchable-system.nix;
  noto-fonts = runTest ./noto-fonts.nix;
  noto-fonts-cjk-qt-default-weight = runTest ./noto-fonts-cjk-qt-default-weight.nix;
  novacomd = handleTestOn [ "x86_64-linux" ] ./novacomd.nix { };
  npmrc = runTest ./npmrc.nix;
  nscd = runTest ./nscd.nix;
  nsd = runTest ./nsd.nix;
  ntfy-sh = handleTest ./ntfy-sh.nix { };
  ntfy-sh-migration = handleTest ./ntfy-sh-migration.nix { };
  ntpd = runTest ./ntpd.nix;
  ntpd-rs = runTest ./ntpd-rs.nix;
  nvidia-container-toolkit = runTest ./nvidia-container-toolkit.nix;
  nvmetcfg = runTest ./nvmetcfg.nix;
  nzbget = runTest ./nzbget.nix;
  nzbhydra2 = runTest ./nzbhydra2.nix;
  ocis = runTest ./ocis.nix;
  oddjobd = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./oddjobd.nix { };
  obs-studio = runTest ./obs-studio.nix;
  oh-my-zsh = runTest ./oh-my-zsh.nix;
  olivetin = runTest ./olivetin.nix;
  ollama = runTest ./ollama.nix;
  ollama-cuda = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-cuda.nix;
  ollama-rocm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-rocm.nix;
  ombi = runTest ./ombi.nix;
  openarena = runTest ./openarena.nix;
  openbao = runTest ./openbao.nix;
  opencloud = runTest ./opencloud.nix;
  openldap = runTest ./openldap.nix;
  openresty-lua = runTest ./openresty-lua.nix;
  opensearch = discoverTests (import ./opensearch.nix);
  opensmtpd = handleTest ./opensmtpd.nix { };
  opensmtpd-rspamd = handleTest ./opensmtpd-rspamd.nix { };
  opensnitch = runTest ./opensnitch.nix;
  openssh = runTest ./openssh.nix;
  octoprint = runTest ./octoprint.nix;
  openstack-image-metadata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).metadata or { };
  openstack-image-userdata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).userdata or { };
  opentabletdriver = runTest ./opentabletdriver.nix;
  opentelemetry-collector = runTest ./opentelemetry-collector.nix;
  open-web-calendar = runTest ./web-apps/open-web-calendar.nix;
  ocsinventory-agent = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./ocsinventory-agent.nix { };
  orthanc = runTest ./orthanc.nix;
  owncast = runTest ./owncast.nix;
  outline = runTest ./outline.nix;
  i18n = runTest ./i18n.nix;
  image-contents = handleTest ./image-contents.nix { };
  openvscode-server = runTest ./openvscode-server.nix;
  open-webui = runTest ./open-webui.nix;
  openvswitch = runTest ./openvswitch.nix;
  orangefs = runTest ./orangefs.nix;
  os-prober = handleTestOn [ "x86_64-linux" ] ./os-prober.nix { };
  osquery = handleTestOn [ "x86_64-linux" ] ./osquery.nix { };
  osrm-backend = runTest ./osrm-backend.nix;
  overlayfs = runTest ./overlayfs.nix;
  pacemaker = runTest ./pacemaker.nix;
  packagekit = runTest ./packagekit.nix;
  pam-file-contents = runTest ./pam/pam-file-contents.nix;
  pam-oath-login = runTest ./pam/pam-oath-login.nix;
  pam-u2f = runTest ./pam/pam-u2f.nix;
  pam-ussh = runTest ./pam/pam-ussh.nix;
  pam-zfs-key = runTest ./pam/zfs-key.nix;
  paretosecurity = runTest ./paretosecurity.nix;
  pass-secret-service = runTest ./pass-secret-service.nix;
  patroni = handleTestOn [ "x86_64-linux" ] ./patroni.nix { };
  pantalaimon = runTest ./matrix/pantalaimon.nix;
  pantheon = runTest ./pantheon.nix;
  pantheon-wayland = runTest ./pantheon-wayland.nix;
  paperless = runTest ./paperless.nix;
  parsedmarc = handleTest ./parsedmarc { };
  password-option-override-ordering = runTest ./password-option-override-ordering.nix;
  pdns-recursor = runTest ./pdns-recursor.nix;
  pds = runTest ./pds.nix;
  peerflix = runTest ./peerflix.nix;
  peering-manager = runTest ./web-apps/peering-manager.nix;
  peertube = handleTestOn [ "x86_64-linux" ] ./web-apps/peertube.nix { };
  peroxide = runTest ./peroxide.nix;
  pgadmin4 = runTest ./pgadmin4.nix;
  pgbackrest = import ./pgbackrest { inherit runTest; };
  pgbouncer = runTest ./pgbouncer.nix;
  pghero = runTest ./pghero.nix;
  pgweb = runTest ./pgweb.nix;
  pgmanage = runTest ./pgmanage.nix;
  phosh = runTest ./phosh.nix;
  photonvision = runTest ./photonvision.nix;
  photoprism = runTest ./photoprism.nix;
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
  phylactery = runTest ./web-apps/phylactery.nix;
  pict-rs = runTest ./pict-rs.nix;
  pingvin-share = runTest ./pingvin-share.nix;
  pinnwand = runTest ./pinnwand.nix;
  plantuml-server = runTest ./plantuml-server.nix;
  plasma-bigscreen = runTest ./plasma-bigscreen.nix;
  plasma5 = runTest ./plasma5.nix;
  plasma6 = runTest ./plasma6.nix;
  plasma5-systemd-start = runTest ./plasma5-systemd-start.nix;
  plausible = runTest ./plausible.nix;
  playwright-python = runTest ./playwright-python.nix;
  please = runTest ./please.nix;
  pleroma = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./pleroma.nix { };
  plikd = runTest ./plikd.nix;
  plotinus = runTest ./plotinus.nix;
  pocket-id = runTest ./pocket-id.nix;
  podgrab = runTest ./podgrab.nix;
  podman = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./podman/default.nix { };
  podman-tls-ghostunnel = handleTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./podman/tls-ghostunnel.nix { };
  polaris = runTest ./polaris.nix;
  pomerium = handleTestOn [ "x86_64-linux" ] ./pomerium.nix { };
  portunus = runTest ./portunus.nix;
  postfix = handleTest ./postfix.nix { };
  postfix-raise-smtpd-tls-security-level =
    handleTest ./postfix-raise-smtpd-tls-security-level.nix
      { };
  postfix-tlspol = runTest ./postfix-tlspol.nix;
  postfixadmin = runTest ./postfixadmin.nix;
  postgres-websockets = runTest ./postgres-websockets.nix;
  postgresql = handleTest ./postgresql { };
  postgrest = runTest ./postgrest.nix;
  powerdns = runTest ./powerdns.nix;
  powerdns-admin = handleTest ./powerdns-admin.nix { };
  power-profiles-daemon = runTest ./power-profiles-daemon.nix;
  pppd = runTest ./pppd.nix;
  predictable-interface-names = handleTest ./predictable-interface-names.nix { };
  pretalx = runTest ./web-apps/pretalx.nix;
  prefect = runTest ./prefect.nix;
  pretix = runTest ./web-apps/pretix.nix;
  printing-socket = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = true;
    _module.args.listenTcp = true;
  };
  printing-service = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = false;
    _module.args.listenTcp = true;
  };
  printing-socket-notcp = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = true;
    _module.args.listenTcp = false;
  };
  printing-service-notcp = runTest {
    imports = [ ./printing.nix ];
    _module.args.socket = false;
    _module.args.listenTcp = false;
  };
  private-gpt = runTest ./private-gpt.nix;
  privatebin = runTest ./privatebin.nix;
  privoxy = runTest ./privoxy.nix;
  prometheus = import ./prometheus { inherit runTest; };
  prometheus-exporters = handleTest ./prometheus-exporters.nix { };
  prosody = handleTest ./xmpp/prosody.nix { };
  prosody-mysql = handleTest ./xmpp/prosody-mysql.nix { };
  proxy = runTest ./proxy.nix;
  prowlarr = runTest ./prowlarr.nix;
  pt2-clone = runTest ./pt2-clone.nix;
  pykms = runTest ./pykms.nix;
  public-inbox = runTest ./public-inbox.nix;
  pufferpanel = runTest ./pufferpanel.nix;
  pulseaudio = discoverTests (import ./pulseaudio.nix);
  qboot = handleTestOn [ "x86_64-linux" "i686-linux" ] ./qboot.nix { };
  qemu-vm-restrictnetwork = handleTest ./qemu-vm-restrictnetwork.nix { };
  qemu-vm-volatile-root = runTest ./qemu-vm-volatile-root.nix;
  qemu-vm-external-disk-image = runTest ./qemu-vm-external-disk-image.nix;
  qemu-vm-store = runTest ./qemu-vm-store.nix;
  qgis = handleTest ./qgis.nix { package = pkgs.qgis; };
  qgis-ltr = handleTest ./qgis.nix { package = pkgs.qgis-ltr; };
  qownnotes = runTest ./qownnotes.nix;
  qtile = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./qtile/default.nix;
  quake3 = runTest ./quake3.nix;
  quicktun = runTest ./quicktun.nix;
  quickwit = runTest ./quickwit.nix;
  quorum = runTest ./quorum.nix;
  rabbitmq = runTest ./rabbitmq.nix;
  radarr = runTest ./radarr.nix;
  radicale = runTest ./radicale.nix;
  radicle = runTest ./radicle.nix;
  ragnarwm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ragnarwm.nix;
  rasdaemon = runTest ./rasdaemon.nix;
  rathole = runTest ./rathole.nix;
  readarr = runTest ./readarr.nix;
  realm = runTest ./realm.nix;
  readeck = runTest ./readeck.nix;
  rebuilderd = runTest ./rebuilderd.nix;
  redis = handleTest ./redis.nix { };
  redlib = runTest ./redlib.nix;
  redmine = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./redmine.nix { };
  renovate = runTest ./renovate.nix;
  replace-dependencies = handleTest ./replace-dependencies { };
  reposilite = runTest ./reposilite.nix;
  restartByActivationScript = runTest ./restart-by-activation-script.nix;
  restic-rest-server = runTest ./restic-rest-server.nix;
  restic = runTest ./restic.nix;
  retroarch = runTest ./retroarch.nix;
  rke2 = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./rke2 { };
  rkvm = handleTest ./rkvm { };
  rmfakecloud = runTest ./rmfakecloud.nix;
  robustirc-bridge = runTest ./robustirc-bridge.nix;
  rosenpass = runTest ./rosenpass.nix;
  roundcube = runTest ./roundcube.nix;
  routinator = handleTest ./routinator.nix { };
  rshim = handleTest ./rshim.nix { };
  rspamd = handleTest ./rspamd.nix { };
  rspamd-trainer = runTest ./rspamd-trainer.nix;
  rss-bridge = handleTest ./web-apps/rss-bridge { };
  rss2email = handleTest ./rss2email.nix { };
  rstudio-server = runTest ./rstudio-server.nix;
  rsyncd = runTest ./rsyncd.nix;
  rsyslogd = handleTest ./rsyslogd.nix { };
  rtkit = runTest ./rtkit.nix;
  rtorrent = runTest ./rtorrent.nix;
  rush = runTest ./rush.nix;
  rustls-libssl = runTest ./rustls-libssl.nix;
  rxe = runTest ./rxe.nix;
  sabnzbd = runTest ./sabnzbd.nix;
  samba = runTest ./samba.nix;
  samba-wsdd = runTest ./samba-wsdd.nix;
  sane = runTest ./sane.nix;
  sanoid = runTest ./sanoid.nix;
  saunafs = runTest ./saunafs.nix;
  scaphandre = handleTest ./scaphandre.nix { };
  schleuder = handleTest ./schleuder.nix { };
  scion-freestanding-deployment = handleTest ./scion/freestanding-deployment { };
  scrutiny = runTest ./scrutiny.nix;
  scx = runTest ./scx/default.nix;
  sddm = handleTest ./sddm.nix { };
  sdl3 = runTest ./sdl3.nix;
  seafile = runTest ./seafile.nix;
  searx = runTest ./searx.nix;
  seatd = runTest ./seatd.nix;
  send = runTest ./send.nix;
  service-runner = runTest ./service-runner.nix;
  servo = runTest ./servo.nix;
  shadps4 = runTest ./shadps4.nix;
  sftpgo = runTest ./sftpgo.nix;
  sfxr-qt = runTest ./sfxr-qt.nix;
  sgt-puzzles = runTest ./sgt-puzzles.nix;
  shadow = runTest ./shadow.nix;
  shadowsocks = handleTest ./shadowsocks { };
  shattered-pixel-dungeon = runTest ./shattered-pixel-dungeon.nix;
  shiori = runTest ./shiori.nix;
  signal-desktop = runTest ./signal-desktop.nix;
  silverbullet = runTest ./silverbullet.nix;
  simple = runTest ./simple.nix;
  sing-box = runTest ./sing-box.nix;
  slimserver = runTest ./slimserver.nix;
  slurm = runTest ./slurm.nix;
  snmpd = runTest ./snmpd.nix;
  smokeping = runTest ./smokeping.nix;
  snapcast = runTest ./snapcast.nix;
  snapper = runTest ./snapper.nix;
  snipe-it = runTest ./web-apps/snipe-it.nix;
  soapui = runTest ./soapui.nix;
  soft-serve = runTest ./soft-serve.nix;
  sogo = runTest ./sogo.nix;
  soju = runTest ./soju.nix;
  solanum = runTest ./solanum.nix;
  sonarr = runTest ./sonarr.nix;
  sonic-server = runTest ./sonic-server.nix;
  sourcehut = handleTest ./sourcehut { };
  spacecookie = runTest ./spacecookie.nix;
  spark = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./spark { };
  spiped = runTest ./spiped.nix;
  sqlite3-to-mysql = runTest ./sqlite3-to-mysql.nix;
  squid = runTest ./squid.nix;
  sslh = handleTest ./sslh.nix { };
  ssh-agent-auth = runTest ./ssh-agent-auth.nix;
  ssh-audit = runTest ./ssh-audit.nix;
  sssd = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd.nix { };
  sssd-ldap = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd-ldap.nix { };
  stalwart-mail = runTest ./stalwart-mail.nix;
  stargazer = runTest ./web-servers/stargazer.nix;
  starship = runTest ./starship.nix;
  stash = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stash.nix { };
  static-web-server = runTest ./web-servers/static-web-server.nix;
  step-ca = handleTestOn [ "x86_64-linux" ] ./step-ca.nix { };
  stratis = handleTest ./stratis { };
  strongswan-swanctl = runTest ./strongswan-swanctl.nix;
  stub-ld = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stub-ld.nix { };
  stunnel = handleTest ./stunnel.nix { };
  sudo = runTest ./sudo.nix;
  sudo-rs = runTest ./sudo-rs.nix;
  sunshine = runTest ./sunshine.nix;
  suricata = runTest ./suricata.nix;
  suwayomi-server = handleTest ./suwayomi-server.nix { };
  swap-file-btrfs = runTest ./swap-file-btrfs.nix;
  swap-partition = runTest ./swap-partition.nix;
  swap-random-encryption = runTest ./swap-random-encryption.nix;
  swapspace = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./swapspace.nix { };
  sway = runTest ./sway.nix;
  swayfx = runTest ./swayfx.nix;
  switchTest = runTest {
    imports = [ ./switch-test.nix ];
    defaults.system.switch.enableNg = false;
  };
  switchTestNg = runTest {
    imports = [ ./switch-test.nix ];
    defaults.system.switch.enableNg = true;
  };
  sx = runTest ./sx.nix;
  sympa = runTest ./sympa.nix;
  syncthing = runTest ./syncthing.nix;
  syncthing-no-settings = runTest ./syncthing-no-settings.nix;
  syncthing-init = runTest ./syncthing-init.nix;
  syncthing-many-devices = runTest ./syncthing-many-devices.nix;
  syncthing-folders = runTest ./syncthing-folders.nix;
  syncthing-relay = runTest ./syncthing-relay.nix;
  sysinit-reactivation = runTest ./sysinit-reactivation.nix;
  systemd = runTest ./systemd.nix;
  systemd-analyze = runTest ./systemd-analyze.nix;
  systemd-binfmt = handleTestOn [ "x86_64-linux" ] ./systemd-binfmt.nix { };
  systemd-boot = handleTest ./systemd-boot.nix { };
  systemd-bpf = runTest ./systemd-bpf.nix;
  systemd-confinement = handleTest ./systemd-confinement { };
  systemd-coredump = runTest ./systemd-coredump.nix;
  systemd-cryptenroll = runTest ./systemd-cryptenroll.nix;
  systemd-credentials-tpm2 = runTest ./systemd-credentials-tpm2.nix;
  systemd-escaping = runTest ./systemd-escaping.nix;
  systemd-initrd-bridge = runTest ./systemd-initrd-bridge.nix;
  systemd-initrd-btrfs-raid = runTest ./systemd-initrd-btrfs-raid.nix;
  systemd-initrd-credentials = runTest ./systemd-initrd-credentials.nix;
  systemd-initrd-luks-fido2 = runTest ./systemd-initrd-luks-fido2.nix;
  systemd-initrd-luks-keyfile = runTest ./systemd-initrd-luks-keyfile.nix;
  systemd-initrd-luks-empty-passphrase = runTest {
    imports = [ ./initrd-luks-empty-passphrase.nix ];
    _module.args.systemdStage1 = true;
  };
  systemd-initrd-luks-password = runTest ./systemd-initrd-luks-password.nix;
  systemd-initrd-luks-tpm2 = runTest ./systemd-initrd-luks-tpm2.nix;
  systemd-initrd-luks-unl0kr = runTest ./systemd-initrd-luks-unl0kr.nix;
  systemd-initrd-modprobe = runTest ./systemd-initrd-modprobe.nix;
  systemd-initrd-networkd = handleTest ./systemd-initrd-networkd.nix { };
  systemd-initrd-networkd-ssh = runTest ./systemd-initrd-networkd-ssh.nix;
  systemd-initrd-networkd-openvpn = handleTestOn [
    "x86_64-linux"
    "i686-linux"
  ] ./initrd-network-openvpn { systemdStage1 = true; };
  systemd-initrd-shutdown = runTest {
    imports = [ ./systemd-shutdown.nix ];
    _module.args.systemdStage1 = true;
  };
  systemd-initrd-simple = runTest ./systemd-initrd-simple.nix;
  systemd-initrd-swraid = runTest ./systemd-initrd-swraid.nix;
  systemd-initrd-vconsole = runTest ./systemd-initrd-vconsole.nix;
  systemd-initrd-vlan = runTest ./systemd-initrd-vlan.nix;
  systemd-journal = runTest ./systemd-journal.nix;
  systemd-journal-gateway = runTest ./systemd-journal-gateway.nix;
  systemd-journal-upload = runTest ./systemd-journal-upload.nix;
  systemd-lock-handler = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./systemd-lock-handler.nix;
  systemd-machinectl = runTest ./systemd-machinectl.nix;
  systemd-networkd = runTest ./systemd-networkd.nix;
  systemd-networkd-bridge = runTest ./systemd-networkd-bridge.nix;
  systemd-networkd-dhcpserver = runTest ./systemd-networkd-dhcpserver.nix;
  systemd-networkd-dhcpserver-static-leases =
    handleTest ./systemd-networkd-dhcpserver-static-leases.nix
      { };
  systemd-networkd-ipv6-prefix-delegation =
    handleTest ./systemd-networkd-ipv6-prefix-delegation.nix
      { };
  systemd-networkd-vrf = runTest ./systemd-networkd-vrf.nix;
  systemd-no-tainted = runTest ./systemd-no-tainted.nix;
  systemd-nspawn = runTest ./systemd-nspawn.nix;
  systemd-nspawn-configfile = runTest ./systemd-nspawn-configfile.nix;
  systemd-oomd = runTest ./systemd-oomd.nix;
  systemd-portabled = runTest ./systemd-portabled.nix;
  systemd-repart = handleTest ./systemd-repart.nix { };
  systemd-resolved = runTest ./systemd-resolved.nix;
  systemd-ssh-proxy = runTest ./systemd-ssh-proxy.nix;
  systemd-shutdown = runTest ./systemd-shutdown.nix;
  systemd-sysupdate = runTest ./systemd-sysupdate.nix;
  systemd-sysusers-mutable = runTest ./systemd-sysusers-mutable.nix;
  systemd-sysusers-immutable = runTest ./systemd-sysusers-immutable.nix;
  systemd-sysusers-password-option-override-ordering = runTest ./systemd-sysusers-password-option-override-ordering.nix;
  systemd-timesyncd = runTest ./systemd-timesyncd.nix;
  systemd-timesyncd-nscd-dnssec = runTest ./systemd-timesyncd-nscd-dnssec.nix;
  systemd-user-linger = runTest ./systemd-user-linger.nix;
  systemd-user-tmpfiles-rules = runTest ./systemd-user-tmpfiles-rules.nix;
  systemd-misc = runTest ./systemd-misc.nix;
  systemd-userdbd = runTest ./systemd-userdbd.nix;
  systemd-homed = runTest ./systemd-homed.nix;
  systemtap = handleTest ./systemtap.nix { };
  startx = import ./startx.nix { inherit pkgs runTest; };
  taler = handleTest ./taler { };
  tandoor-recipes = runTest ./tandoor-recipes.nix;
  tandoor-recipes-script-name = runTest ./tandoor-recipes-script-name.nix;
  tang = runTest ./tang.nix;
  taskserver = runTest ./taskserver.nix;
  taskchampion-sync-server = runTest ./taskchampion-sync-server.nix;
  tayga = runTest ./tayga.nix;
  technitium-dns-server = runTest ./technitium-dns-server.nix;
  teeworlds = runTest ./teeworlds.nix;
  telegraf = runTest ./telegraf.nix;
  teleport = handleTest ./teleport.nix { };
  teleports = runTest ./teleports.nix;
  thelounge = handleTest ./thelounge.nix { };
  terminal-emulators = handleTest ./terminal-emulators.nix { };
  thanos = handleTest ./thanos.nix { };
  tiddlywiki = runTest ./tiddlywiki.nix;
  tigervnc = handleTest ./tigervnc.nix { };
  tika = runTest ./tika.nix;
  timezone = runTest ./timezone.nix;
  timidity = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./timidity { };
  tinc = handleTest ./tinc { };
  tinydns = runTest ./tinydns.nix;
  tinyproxy = runTest ./tinyproxy.nix;
  tinywl = runTest ./tinywl.nix;
  tmate-ssh-server = runTest ./tmate-ssh-server.nix;
  tomcat = runTest ./tomcat.nix;
  tor = runTest ./tor.nix;
  tpm-ek = handleTest ./tpm-ek { };
  traefik = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./traefik.nix;
  trafficserver = runTest ./trafficserver.nix;
  transfer-sh = runTest ./transfer-sh.nix;
  transmission_3 = handleTest ./transmission.nix { transmission = pkgs.transmission_3; };
  transmission_4 = handleTest ./transmission.nix { transmission = pkgs.transmission_4; };
  # tracee requires bpf
  tracee = handleTestOn [ "x86_64-linux" ] ./tracee.nix { };
  trezord = runTest ./trezord.nix;
  trickster = runTest ./trickster.nix;
  trilium-server = handleTestOn [ "x86_64-linux" ] ./trilium-server.nix { };
  tsm-client-gui = runTest ./tsm-client-gui.nix;
  ttyd = runTest ./web-servers/ttyd.nix;
  tt-rss = runTest ./web-apps/tt-rss.nix;
  txredisapi = runTest ./txredisapi.nix;
  tuptime = runTest ./tuptime.nix;
  turbovnc-headless-server = runTest ./turbovnc-headless-server.nix;
  turn-rs = runTest ./turn-rs.nix;
  tusd = runTest ./tusd/default.nix;
  tuxguitar = runTest ./tuxguitar.nix;
  twingate = runTest ./twingate.nix;
  typesense = runTest ./typesense.nix;
  tzupdate = runTest ./tzupdate.nix;
  ucarp = runTest ./ucarp.nix;
  udisks2 = runTest ./udisks2.nix;
  ulogd = runTest ./ulogd/ulogd.nix;
  umurmur = runTest ./umurmur.nix;
  unbound = runTest ./unbound.nix;
  unifi = runTest ./unifi.nix;
  unit-php = runTest ./web-servers/unit-php.nix;
  unit-perl = runTest ./web-servers/unit-perl.nix;
  upnp.iptables = handleTest ./upnp.nix { useNftables = false; };
  upnp.nftables = handleTest ./upnp.nix { useNftables = true; };
  uptermd = runTest ./uptermd.nix;
  uptime-kuma = runTest ./uptime-kuma.nix;
  urn-timer = runTest ./urn-timer.nix;
  usbguard = runTest ./usbguard.nix;
  userborn = runTest ./userborn.nix;
  userborn-mutable-users = runTest ./userborn-mutable-users.nix;
  userborn-immutable-users = runTest ./userborn-immutable-users.nix;
  userborn-mutable-etc = runTest ./userborn-mutable-etc.nix;
  userborn-immutable-etc = runTest ./userborn-immutable-etc.nix;
  user-activation-scripts = runTest ./user-activation-scripts.nix;
  user-enable-option = runTest ./user-enable-option.nix;
  user-expiry = runTest ./user-expiry.nix;
  user-home-mode = runTest ./user-home-mode.nix;
  ustreamer = runTest ./ustreamer.nix;
  uwsgi = runTest ./uwsgi.nix;
  v2ray = runTest ./v2ray.nix;
  varnish60 = runTest {
    imports = [ ./varnish.nix ];
    _module.args.package = pkgs.varnish60;
  };
  varnish77 = runTest {
    imports = [ ./varnish.nix ];
    _module.args.package = pkgs.varnish77;
  };
  vault = runTest ./vault.nix;
  vault-agent = runTest ./vault-agent.nix;
  vault-dev = runTest ./vault-dev.nix;
  vault-postgresql = runTest ./vault-postgresql.nix;
  vaultwarden = discoverTests (import ./vaultwarden.nix);
  vdirsyncer = runTest ./vdirsyncer.nix;
  vector = handleTest ./vector { };
  velocity = runTest ./velocity.nix;
  vengi-tools = runTest ./vengi-tools.nix;
  victoriametrics = handleTest ./victoriametrics { };
  vikunja = runTest ./vikunja.nix;
  virtualbox = handleTestOn [ "x86_64-linux" ] ./virtualbox.nix { };
  vm-variant = handleTest ./vm-variant.nix { };
  vscode-remote-ssh = handleTestOn [ "x86_64-linux" ] ./vscode-remote-ssh.nix { };
  vscodium = discoverTests (import ./vscodium.nix);
  vsftpd = runTest ./vsftpd.nix;
  waagent = runTest ./waagent.nix;
  wakapi = runTest ./wakapi.nix;
  warzone2100 = runTest ./warzone2100.nix;
  wasabibackend = runTest ./wasabibackend.nix;
  wastebin = runTest ./wastebin.nix;
  watchdogd = runTest ./watchdogd.nix;
  webhook = runTest ./webhook.nix;
  weblate = runTest ./web-apps/weblate.nix;
  whisparr = runTest ./whisparr.nix;
  whoami = runTest ./whoami.nix;
  whoogle-search = runTest ./whoogle-search.nix;
  wiki-js = runTest ./wiki-js.nix;
  wine = handleTest ./wine.nix { };
  wireguard = handleTest ./wireguard { };
  wg-access-server = runTest ./wg-access-server.nix;
  without-nix = runTest ./without-nix.nix;
  wmderland = runTest ./wmderland.nix;
  workout-tracker = runTest ./workout-tracker.nix;
  wpa_supplicant = import ./wpa_supplicant.nix { inherit pkgs runTest; };
  wordpress = runTest ./wordpress.nix;
  wrappers = runTest ./wrappers.nix;
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
  zwave-js = runTest ./zwave-js.nix;
  zwave-js-ui = runTest ./zwave-js-ui.nix;
}
