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
let
  inherit (pkgs.lib)
    isAttrs
    isFunction
    mapAttrs
    elem
    recurseIntoAttrs
    ;

  # TODO: remove when handleTest is gone (make sure nixosTests and nixos/release.nix#tests are unaffected)
  # TODO: when removing, also deprecate `test` attribute in ../lib/testing/run.nix
  discoverTests =
    val:
    if isAttrs val then
      if (val ? test) then
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
  evalSystem =
    module:
    import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../modules/misc/nixpkgs/read-only.nix
        { nixpkgs.pkgs = pkgs; }
        module
      ];
    };

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
    console-log = runTest ./nixos-test-driver/console-log.nix;
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
  acme = import ./acme/default.nix {
    inherit runTest;
    inherit (pkgs) lib;
  };
  acme-dns = runTest ./acme-dns.nix;
  activation = pkgs.callPackage ../modules/system/activation/test.nix { };
  activation-bashless = runTest ./activation/bashless.nix;
  activation-bashless-closure = pkgs.callPackage ./activation/bashless-closure.nix { };
  activation-bashless-image = runTest ./activation/bashless-image.nix;
  activation-etc-overlay-immutable = runTest ./activation/etc-overlay-immutable.nix;
  activation-etc-overlay-mutable = runTest ./activation/etc-overlay-mutable.nix;
  activation-lib = pkgs.callPackage ../modules/system/activation/lib/test.nix { };
  activation-nix-channel = runTest ./activation/nix-channel.nix;
  activation-nixos-init = runTest ./activation/nixos-init.nix;
  activation-perlless = runTest ./activation/perlless.nix;
  activation-var = runTest ./activation/var.nix;
  actual = runTest ./actual.nix;
  adguardhome = runTest ./adguardhome.nix;
  aesmd = runTestOn [ "x86_64-linux" ] ./aesmd.nix;
  agate = runTest ./web-servers/agate.nix;
  agda = import ./agda {
    inherit runTest;
  };
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
  android-translation-layer = runTest ./android-translation-layer.nix;
  angie-api = runTest ./angie-api.nix;
  angrr = runTest ./angrr.nix;
  anki-sync-server = runTest ./anki-sync-server.nix;
  anubis = runTest ./anubis.nix;
  anuko-time-tracker = runTest ./anuko-time-tracker.nix;
  apcupsd = runTest ./apcupsd.nix;
  apfs = runTest ./apfs.nix;
  apparmor = runTest ./apparmor;
  appliance-repart-image = runTest ./appliance-repart-image.nix;
  appliance-repart-image-verity-store = runTest ./appliance-repart-image-verity-store.nix;
  aria2 = runTest ./aria2.nix;
  armagetronad = runTest ./armagetronad.nix;
  artalk = runTest ./artalk.nix;
  atd = runTest ./atd.nix;
  atop = import ./atop.nix { inherit pkgs runTest; };
  atticd = runTest ./atticd.nix;
  atuin = runTest ./atuin.nix;
  audiobookshelf = runTest ./audiobookshelf.nix;
  audit = runTest ./audit.nix;
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
  ax25 = runTest ./ax25.nix;
  ayatana-indicators = runTest ./ayatana-indicators.nix;
  babeld = runTest ./babeld.nix;
  bazarr = runTest ./bazarr.nix;
  bcache = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./bcache.nix;
  bcachefs = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./bcachefs.nix;
  beanstalkd = runTest ./beanstalkd.nix;
  bees = runTest ./bees.nix;
  benchexec = runTest ./benchexec.nix;
  beszel = runTest ./beszel.nix;
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
  bird2 = import ./bird.nix {
    inherit runTest;
    package = pkgs.bird2;
  };
  bird3 = import ./bird.nix {
    inherit runTest;
    package = pkgs.bird3;
  };
  birdwatcher = runTest ./birdwatcher.nix;
  bitbox-bridge = runTest ./bitbox-bridge.nix;
  bitcoind = runTest ./bitcoind.nix;
  bittorrent = runTest ./bittorrent.nix;
  blint = runTest ./blint.nix;
  blockbook-frontend = runTest ./blockbook-frontend.nix;
  blocky = runTest ./blocky.nix;
  bluesky-pds = runTest ./bluesky-pds.nix;
  bookstack = runTest ./bookstack.nix;
  boot = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./boot.nix { };
  boot-stage1 = runTest ./boot-stage1.nix;
  boot-stage2 = runTest ./boot-stage2.nix;
  bootspec = handleTestOn [ "x86_64-linux" ] ./bootspec.nix { };
  borgbackup = runTest ./borgbackup.nix;
  borgmatic = runTest ./borgmatic.nix;
  botamusique = runTest ./botamusique.nix;
  bpf = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./bpf.nix;
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
  cadvisor = runTestOn [ "x86_64-linux" ] ./cadvisor.nix;
  cage = runTest ./cage.nix;
  cagebreak = runTest ./cagebreak.nix;
  calibre-server = import ./calibre-server.nix { inherit pkgs runTest; };
  calibre-web = runTest ./calibre-web.nix;
  canaille = runTest ./canaille.nix;
  cassandra = runTest {
    imports = [ ./cassandra.nix ];
    _module.args.getPackage = pkgs: pkgs.cassandra;
  };
  castopod = runTest ./castopod.nix;
  centrifugo = runTest ./centrifugo.nix;
  ceph-multi-node = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./ceph-multi-node.nix;
  ceph-single-node = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./ceph-single-node.nix;
  ceph-single-node-bluestore = runTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./ceph-single-node-bluestore.nix;
  ceph-single-node-bluestore-dmcrypt = runTestOn [
    "aarch64-linux"
    "x86_64-linux"
  ] ./ceph-single-node-bluestore-dmcrypt.nix;
  certmgr = import ./certmgr.nix { inherit pkgs runTest; };
  cfssl = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./cfssl.nix;
  cgit = runTest ./cgit.nix;
  charliecloud = runTest ./charliecloud.nix;
  chhoto-url = runTest ./chhoto-url.nix;
  chromadb = runTest ./chromadb.nix;
  chromium = (handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./chromium.nix { }).stable or { };
  chrony = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony.nix;
  chrony-ptp = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./chrony-ptp.nix;
  cinnamon = runTest ./cinnamon.nix;
  cinnamon-wayland = runTest ./cinnamon-wayland.nix;
  cjdns = runTest ./cjdns.nix;
  clamav = runTest ./clamav.nix;
  clatd = runTest ./clatd.nix;
  clickhouse = import ./clickhouse {
    inherit runTest;
    package = pkgs.clickhouse;
  };
  clickhouse-lts = import ./clickhouse {
    inherit runTest;
    package = pkgs.clickhouse-lts;
  };
  cloud-init = runTest ./cloud-init.nix;
  cloud-init-hostname = runTest ./cloud-init-hostname.nix;
  cloudlog = runTest ./cloudlog.nix;
  cntr = import ./cntr.nix {
    inherit (pkgs) lib;
    runTest = runTestOn [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
  cockpit = runTest ./cockpit.nix;
  cockroachdb = runTestOn [ "x86_64-linux" ] ./cockroachdb.nix;
  code-server = runTest ./code-server.nix;
  coder = runTest ./coder.nix;
  collectd = runTest ./collectd.nix;
  commafeed = runTest ./commafeed.nix;
  connman = runTest ./connman.nix;
  consul = runTest ./consul.nix;
  consul-template = runTest ./consul-template.nix;
  containers-bridge = runTest ./containers-bridge.nix;
  containers-custom-pkgs = runTest ./containers-custom-pkgs.nix;
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
  corerad = runTest ./corerad.nix;
  corteza = runTest ./corteza.nix;
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
  coturn = runTest ./coturn.nix;
  couchdb = runTest ./couchdb.nix;
  crabfit = runTest ./crabfit.nix;
  cri-o = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./cri-o.nix;
  croc = runTest ./croc.nix;
  cross-seed = runTest ./cross-seed.nix;
  cryptpad = runTest ./cryptpad.nix;
  cups-pdf = runTest ./cups-pdf.nix;
  curl-impersonate = runTest ./curl-impersonate.nix;
  custom-ca = import ./custom-ca.nix { inherit pkgs runTest; };
  cyrus-imap = runTest ./cyrus-imap.nix;
  dae = runTest ./dae.nix;
  darling-dmg = runTest ./darling-dmg.nix;
  dashy = runTest ./web-apps/dashy.nix;
  davis = runTest ./davis.nix;
  db-rest = runTest ./db-rest.nix;
  dconf = runTest ./dconf.nix;
  ddns-updater = runTest ./ddns-updater.nix;
  deconz = runTest ./deconz.nix;
  deluge = runTest ./deluge.nix;
  dendrite = runTest ./matrix/dendrite.nix;
  dep-scan = runTest ./dep-scan.nix;
  dependency-track = runTest ./dependency-track.nix;
  devpi-server = runTest ./devpi-server.nix;
  dex-oidc = runTest ./dex-oidc.nix;
  dhparams = runTest ./dhparams.nix;
  dictd = runTest ./dictd.nix;
  disable-installer-tools = runTest ./disable-installer-tools.nix;
  discourse = runTest {
    imports = [ ./discourse.nix ];
    _module.args.package = pkgs.discourse;
  };
  discourseAllPlugins = runTest {
    imports = [ ./discourse.nix ];
    _module.args.package = pkgs.discourseAllPlugins;
  };
  dnscrypt-proxy = runTestOn [ "x86_64-linux" ] ./dnscrypt-proxy.nix;
  dnsdist = import ./dnsdist.nix { inherit pkgs runTest; };
  doas = runTest ./doas.nix;
  docker = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker.nix;
  docker-registry = runTest ./docker-registry.nix;
  docker-rootless = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./docker-rootless.nix;
  docker-tools = runTestOn [ "x86_64-linux" ] ./docker-tools.nix;
  docker-tools-cross = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./docker-tools-cross.nix;
  docker-tools-nix-shell = runTest ./docker-tools-nix-shell.nix;
  docker-tools-overlay = runTestOn [ "x86_64-linux" ] ./docker-tools-overlay.nix;
  docling-serve = runTest ./docling-serve.nix;
  documentation = pkgs.callPackage ../modules/misc/documentation/test.nix { inherit nixosLib; };
  documize = runTest ./documize.nix;
  docuseal-psql = runTest ./docuseal-postgres.nix;
  docuseal-sqlite = runTest ./docuseal-sqlite.nix;
  doh-proxy-rust = runTest ./doh-proxy-rust.nix;
  dokuwiki = runTest ./dokuwiki.nix;
  dolibarr = runTest ./dolibarr.nix;
  domination = runTest ./domination.nix;
  dovecot = runTest ./dovecot.nix;
  draupnir = runTest ./matrix/draupnir.nix;
  drawterm = discoverTests (import ./drawterm.nix);
  drbd = runTest ./drbd.nix;
  drbd-driver = runTest ./drbd-driver.nix;
  druid = handleTestOn [ "x86_64-linux" ] ./druid { };
  drupal = runTest ./drupal.nix;
  dublin-traceroute = runTest ./dublin-traceroute.nix;
  dwl = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./dwl.nix;
  early-mount-options = runTest ./early-mount-options.nix;
  earlyoom = runTestOn [ "x86_64-linux" ] ./earlyoom.nix;
  easytier = runTest ./easytier.nix;
  ec2-config = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-config or { };
  ec2-nixops = (handleTestOn [ "x86_64-linux" ] ./ec2.nix { }).boot-ec2-nixops or { };
  echoip = runTest ./echoip.nix;
  ecryptfs = runTest ./ecryptfs.nix;
  ejabberd = runTest ./xmpp/ejabberd.nix;
  elk = handleTestOn [ "x86_64-linux" ] ./elk.nix { };
  emacs-daemon = runTest ./emacs-daemon.nix;
  endlessh = runTest ./endlessh.nix;
  endlessh-go = runTest ./endlessh-go.nix;
  engelsystem = runTest ./engelsystem.nix;
  enlightenment = runTest ./enlightenment.nix;
  ente = runTest ./ente;
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
  ersatztv = handleTest ./ersatztv.nix { };
  espanso = import ./espanso.nix {
    inherit (pkgs) lib;
    inherit runTest;
  };
  esphome = runTest ./esphome.nix;
  etc = pkgs.callPackage ../modules/system/etc/test.nix { inherit evalMinimalConfig; };
  etcd = import ./etcd/default.nix { inherit pkgs runTest; };
  etebase-server = runTest ./etebase-server.nix;
  etesync-dav = runTest ./etesync-dav.nix;
  evcc = runTest ./evcc.nix;
  facter = runTest ./facter;
  fail2ban = runTest ./fail2ban.nix;
  fakeroute = runTest ./fakeroute.nix;
  fancontrol = runTest ./fancontrol.nix;
  fanout = runTest ./fanout.nix;
  fastnetmon-advanced = runTest ./fastnetmon-advanced.nix;
  fcitx5 = runTest ./fcitx5;
  fedimintd = runTest ./fedimintd.nix;
  ferm = runTest ./ferm.nix;
  ferretdb = import ./ferretdb.nix { inherit pkgs runTest; };
  fider = runTest ./fider.nix;
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
  firefox-esr-140 = runTest {
    imports = [ ./firefox.nix ];
    _module.args.firefoxPackage = pkgs.firefox-esr-140;
  };
  firefox-syncserver = runTest ./firefox-syncserver.nix;
  firefoxpwa = runTest ./firefoxpwa.nix;
  firejail = runTest ./firejail.nix;
  firewall = runTest {
    imports = [ ./firewall.nix ];
    _module.args.backend = "iptables";
  };
  firewall-firewalld = runTest {
    imports = [ ./firewall.nix ];
    _module.args.backend = "firewalld";
  };
  firewall-nftables = runTest {
    imports = [ ./firewall.nix ];
    _module.args.backend = "nftables";
  };
  firewalld = runTest ./firewalld.nix;
  firezone = runTest ./firezone/firezone.nix;
  fish = runTest ./fish.nix;
  flannel = runTestOn [ "x86_64-linux" ] ./flannel.nix;
  flaresolverr = runTest ./flaresolverr.nix;
  flood = runTest ./flood.nix;
  fluent-bit = runTest ./fluent-bit.nix;
  fluentd = runTest ./fluentd.nix;
  fluidd = runTest ./fluidd.nix;
  fontconfig-bitmap-fonts = runTest ./fontconfig-bitmap-fonts.nix;
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
  freshrss = import ./freshrss { inherit runTest; };
  frigate = runTest ./frigate.nix;
  froide-govplan = runTest ./web-apps/froide-govplan.nix;
  frp = runTest ./frp.nix;
  frr = runTest ./frr.nix;
  fsck = runTest {
    imports = [ ./fsck.nix ];
    _module.args.systemdStage1 = false;
  };
  fsck-systemd-stage-1 = runTest {
    imports = [ ./fsck.nix ];
    _module.args.systemdStage1 = true;
  };
  fscrypt = runTest ./fscrypt.nix;
  ft2-clone = runTest ./ft2-clone.nix;
  galene = discoverTests (import ./galene.nix { inherit runTest; });
  gancio = runTest ./gancio.nix;
  garage_1 = import ./garage {
    inherit runTest;
    package = pkgs.garage_1;
  };
  garage_2 = import ./garage {
    inherit runTest;
    package = pkgs.garage_2;
  };
  gatus = runTest ./gatus.nix;
  gemstash = import ./gemstash.nix { inherit pkgs runTest; };
  geoclue2 = runTest ./geoclue2.nix;
  geoserver = runTest ./geoserver.nix;
  gerrit = runTest ./gerrit.nix;
  getaddrinfo = runTest ./getaddrinfo.nix;
  geth = runTest ./geth.nix;
  ghostunnel = runTest ./ghostunnel.nix;
  ghostunnel-modular = runTest ./ghostunnel-modular.nix;
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
  gns3-server = runTest ./gns3-server.nix;
  gnupg = runTest ./gnupg.nix;
  go-camo = runTest ./go-camo.nix;
  go-csp-collector = runTest ./go-csp-collector.nix;
  go-httpbin = runTest ./go-httpbin.nix;
  go-neb = runTest ./go-neb.nix;
  goatcounter = runTest ./goatcounter.nix;
  gobgpd = runTest ./gobgpd.nix;
  gocd-agent = runTest ./gocd-agent.nix;
  gocd-server = runTest ./gocd-server.nix;
  gokapi = runTest ./gokapi.nix;
  gollum = runTest ./gollum.nix;
  gonic = runTest ./gonic.nix;
  google-oslogin = runTest ./google-oslogin;
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
  h2o = import ./web-servers/h2o {
    inherit runTest;
    inherit (pkgs) lib;
  };
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
  hardened = runTest ./hardened.nix;
  harmonia = runTest ./harmonia.nix;
  haste-server = runTest ./haste-server.nix;
  hbase2 = runTest {
    imports = [ ./hbase.nix ];
    _module.args.getPackage = pkgs: pkgs.hbase2;
  };
  hbase3 = runTest {
    imports = [ ./hbase.nix ];
    _module.args.getPackage = pkgs: pkgs.hbase3;
  };
  hbase_2_4 = runTest {
    imports = [ ./hbase.nix ];
    _module.args.getPackage = pkgs: pkgs.hbase_2_4;
  };
  hbase_2_5 = runTest {
    imports = [ ./hbase.nix ];
    _module.args.getPackage = pkgs: pkgs.hbase_2_5;
  };
  headscale = runTest ./headscale.nix;
  healthchecks = runTest ./web-apps/healthchecks.nix;
  hedgedoc = runTest ./hedgedoc.nix;
  herbstluftwm = runTest ./herbstluftwm.nix;
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
  homebox = runTest ./homebox.nix;
  homebridge = runTest ./homebridge.nix;
  homepage-dashboard = runTest ./homepage-dashboard.nix;
  homer = handleTest ./homer { };
  honk = runTest ./honk.nix;
  hoogle = runTest ./hoogle.nix;
  hostname = handleTest ./hostname.nix { };
  hound = runTest ./hound.nix;
  hub = runTest ./git/hub.nix;
  hydra = runTest ./hydra;
  i18n = runTest ./i18n.nix;
  i3wm = runTest ./i3wm.nix;
  icingaweb2 = runTest ./icingaweb2.nix;
  ifm = runTest ./ifm.nix;
  ifstate = import ./ifstate { inherit runTest; };
  iftop = runTest ./iftop.nix;
  image-contents = handleTest ./image-contents.nix { };
  immich = runTest ./web-apps/immich.nix;
  immich-public-proxy = runTest ./web-apps/immich-public-proxy.nix;
  immich-vectorchord-migration = runTest ./web-apps/immich-vectorchord-migration.nix;
  immich-vectorchord-reindex = runTest ./web-apps/immich-vectorchord-reindex.nix;
  incron = runTest ./incron.nix;
  incus = import ./incus {
    inherit runTestOn;
    package = pkgs.incus;
  };
  incus-lts = import ./incus {
    inherit runTestOn;
    package = pkgs.incus-lts;
  };
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
  installed-tests = recurseIntoAttrs (handleTest ./installed-tests { });
  installer = handleTest ./installer.nix { };
  installer-systemd-stage-1 = handleTest ./installer-systemd-stage-1.nix { };
  intune = runTest ./intune.nix;
  invidious = runTest ./invidious.nix;
  iodine = runTest ./iodine.nix;
  iosched = runTest ./iosched.nix;
  ipget = runTest ./ipget.nix;
  ipv6 = runTest ./ipv6.nix;
  irqbalance = runTest ./irqbalance.nix;
  iscsi-multipath-root = runTest ./iscsi-multipath-root.nix;
  iscsi-root = runTest ./iscsi-root.nix;
  isolate = runTest ./isolate.nix;
  isso = runTest ./isso.nix;
  jackett = runTest ./jackett.nix;
  jellyfin = runTest ./jellyfin.nix;
  jellyseerr = runTest ./jellyseerr.nix;
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
  kernel-generic = handleTest ./kernel-generic { };
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
  kubo = import ./kubo {
    inherit runTest;
    inherit (pkgs) lib;
  };
  lact = runTest ./lact.nix;
  ladybird = runTest ./ladybird.nix;
  languagetool = runTest ./languagetool.nix;
  lanraragi = runTest ./lanraragi.nix;
  lasuite-docs = runTest ./web-apps/lasuite-docs.nix;
  lasuite-meet = runTest ./web-apps/lasuite-meet.nix;
  latestKernel.login = runTest {
    imports = [ ./login.nix ];
    _module.args.latestKernel = true;
  };
  lauti = runTest ./lauti.nix;
  lavalink = runTest ./lavalink.nix;
  leaps = runTest ./leaps.nix;
  legit = runTest ./legit.nix;
  lemmy = runTest ./lemmy.nix;
  lemurs = runTest ./lemurs/lemurs.nix;
  lemurs-wayland = runTest ./lemurs/lemurs-wayland.nix;
  lemurs-wayland-script = runTest ./lemurs/lemurs-wayland-script.nix;
  lemurs-xorg = runTest ./lemurs/lemurs-xorg.nix;
  lemurs-xorg-script = runTest ./lemurs/lemurs-xorg-script.nix;
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
  limesurvey = runTest ./limesurvey.nix;
  limine = import ./limine { inherit runTest; };
  linkwarden = runTest ./web-apps/linkwarden.nix;
  listmonk = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./listmonk.nix { };
  litellm = runTest ./litellm.nix;
  litestream = runTest ./litestream.nix;
  livebook-service = runTest ./livebook-service.nix;
  livekit = runTest ./networking/livekit.nix;
  lk-jwt-service = runTest ./matrix/lk-jwt-service.nix;
  llama-swap = runTest ./web-servers/llama-swap.nix;
  lldap = runTest ./lldap.nix;
  local-content-share = runTest ./local-content-share.nix;
  localsend = runTest ./localsend.nix;
  locate = runTest ./locate.nix;
  login = runTest ./login.nix;
  logkeys = runTest ./logkeys.nix;
  logrotate = runTest ./logrotate.nix;
  loki = runTest ./loki.nix;
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
  luks = runTest ./luks.nix;
  lvm2 = handleTest ./lvm2 { };
  lxc = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./lxc;
  lxd-image-server = runTest ./lxd-image-server.nix;
  lxqt = runTest ./lxqt.nix;
  ly = runTest ./ly.nix;
  maddy = discoverTests (import ./maddy { inherit handleTest; });
  maestral = runTest ./maestral.nix;
  magic-wormhole-mailbox-server = runTest ./magic-wormhole-mailbox-server.nix;
  magnetico = runTest ./magnetico.nix;
  mailcatcher = runTest ./mailcatcher.nix;
  mailhog = runTest ./mailhog.nix;
  mailman = runTest ./mailman.nix;
  mailpit = runTest ./mailpit.nix;
  man = runTest ./man.nix;
  mariadb-galera = handleTest ./mysql/mariadb-galera.nix { };
  marytts = runTest ./marytts.nix;
  mastodon = recurseIntoAttrs (handleTest ./web-apps/mastodon { inherit handleTestOn; });
  mate = runTest ./mate.nix;
  mate-wayland = runTest ./mate-wayland.nix;
  matomo = runTest ./matomo.nix;
  matrix-alertmanager = runTest ./matrix/matrix-alertmanager.nix;
  matrix-appservice-irc = runTest ./matrix/appservice-irc.nix;
  matrix-conduit = runTest ./matrix/conduit.nix;
  matrix-continuwuity = runTest ./matrix/continuwuity.nix;
  matrix-synapse = runTest ./matrix/synapse.nix;
  matrix-synapse-workers = runTest ./matrix/synapse-workers.nix;
  matrix-tuwunel = runTest ./matrix/tuwunel.nix;
  matter-server = runTest ./matter-server.nix;
  mattermost = handleTest ./mattermost { };
  mautrix-discord = runTest ./matrix/mautrix-discord.nix;
  mautrix-meta-postgres = runTest ./matrix/mautrix-meta-postgres.nix;
  mautrix-meta-sqlite = runTest ./matrix/mautrix-meta-sqlite.nix;
  mealie = runTest ./mealie.nix;
  mediamtx = runTest ./mediamtx.nix;
  mediatomb = runTest ./mediatomb.nix;
  mediawiki = handleTest ./mediawiki.nix { };
  meilisearch = runTest ./meilisearch.nix;
  memcached = runTest ./memcached.nix;
  merecat = runTest ./merecat.nix;
  metabase = runTest ./metabase.nix;
  mihomo = runTest ./mihomo.nix;
  mimir = runTest ./mimir.nix;
  mindustry = runTest ./mindustry.nix;
  minecraft-server = runTest ./minecraft-server.nix;
  minidlna = runTest ./minidlna.nix;
  miniflux = runTest ./miniflux.nix;
  minio = runTest ./minio.nix;
  miracle-wm = runTest ./miracle-wm.nix;
  miriway = runTest ./miriway.nix;
  misc = runTest ./misc.nix;
  misskey = runTest ./misskey.nix;
  mitmproxy = runTest ./mitmproxy.nix;
  mjolnir = runTest ./matrix/mjolnir.nix;
  mobilizon = runTest ./mobilizon.nix;
  mod_perl = runTest ./mod_perl.nix;
  modular-service-etc = runTest ./modular-service-etc/test.nix;
  modularService = pkgs.callPackage ../modules/system/service/systemd/test.nix {
    inherit evalSystem;
  };
  molly-brown = runTest ./molly-brown.nix;
  mollysocket = runTest ./mollysocket.nix;
  monado = runTest ./monado.nix;
  monetdb = runTest ./monetdb.nix;
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
  moonraker = runTest ./moonraker.nix;
  moosefs = runTest ./moosefs.nix;
  mopidy = runTest ./mopidy.nix;
  morph-browser = runTest ./morph-browser.nix;
  mosquitto = runTest ./mosquitto.nix;
  movim = import ./web-apps/movim {
    inherit runTest;
    inherit (pkgs) lib;
  };
  mpd = runTest ./mpd.nix;
  mpv = runTest ./mpv.nix;
  mtp = runTest ./mtp.nix;
  multipass = runTest ./multipass.nix;
  mumble = runTest ./mumble.nix;
  munge = runTest ./munge.nix;
  munin = runTest ./munin.nix;
  # Fails on aarch64-linux at the PDF creation step - need to debug this on an
  # aarch64 machine..
  musescore = runTestOn [ "x86_64-linux" ] ./musescore.nix;
  music-assistant = runTest ./music-assistant.nix;
  mutableUsers = runTest ./mutable-users.nix;
  mycelium = runTest ./mycelium;
  mympd = runTest ./mympd.nix;
  mysql = handleTest ./mysql/mysql.nix { };
  mysql-autobackup = handleTest ./mysql/mysql-autobackup.nix { };
  mysql-backup = handleTest ./mysql/mysql-backup.nix { };
  mysql-replication = handleTest ./mysql/mysql-replication.nix { };
  n8n = runTest ./n8n.nix;
  nagios = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./nagios.nix;
  nar-serve = runTest ./nar-serve.nix;
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
  nebula-lighthouse-service = runTest ./nebula-lighthouse-service.nix;
  nebula.connectivity = runTest ./nebula/connectivity.nix;
  nebula.reload = runTest ./nebula/reload.nix;
  neo4j = runTest ./neo4j.nix;
  netbird = runTest ./netbird.nix;
  netbox-upgrade = runTest ./web-apps/netbox-upgrade.nix;
  netbox_4_2 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_2; };
  netbox_4_3 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_3; };
  netbox_4_4 = handleTest ./web-apps/netbox/default.nix { netbox = pkgs.netbox_4_4; };
  netdata = runTest ./netdata.nix;
  networking.networkd = handleTest ./networking/networkd-and-scripted.nix { networkd = true; };
  networking.networkmanager = handleTest ./networking/networkmanager.nix { };
  networking.scripted = handleTest ./networking/networkd-and-scripted.nix { networkd = false; };
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
  nimdow = runTest ./nimdow.nix;
  nipap = runTest ./web-apps/nipap.nix;
  nitter = runTest ./nitter.nix;
  nix-channel = pkgs.callPackage ../modules/config/nix-channel/test.nix { };
  nix-config = runTest ./nix-config.nix;
  nix-ld = runTest ./nix-ld.nix;
  nix-misc = handleTest ./nix/misc.nix { };
  nix-required-mounts = runTest ./nix-required-mounts;
  nix-serve = runTest ./nix-serve.nix;
  nix-serve-ssh = runTest ./nix-serve-ssh.nix;
  nix-store-veritysetup = runTest ./nix-store-veritysetup.nix;
  nix-upgrade = handleTest ./nix/upgrade.nix {
    inherit (pkgs) nixVersions;
    inherit system;
  };
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
  nixseparatedebuginfod2 = runTest ./nixseparatedebuginfod2.nix;
  node-red = runTest ./node-red.nix;
  nomad = runTest ./nomad.nix;
  nominatim = runTest ./nominatim.nix;
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
  nvme-rs = runTest ./nvme-rs.nix;
  nvmetcfg = runTest ./nvmetcfg.nix;
  nyxt = runTest ./nyxt.nix;
  nzbget = runTest ./nzbget.nix;
  nzbhydra2 = runTest ./nzbhydra2.nix;
  obs-studio = runTest ./obs-studio.nix;
  oci-containers = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./oci-containers.nix { };
  ocis = runTest ./ocis.nix;
  ocsinventory-agent = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./ocsinventory-agent.nix { };
  octoprint = runTest ./octoprint.nix;
  oddjobd = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./oddjobd.nix { };
  odoo = runTest ./odoo.nix;
  odoo16 = runTest {
    imports = [ ./odoo.nix ];
    _module.args.package = pkgs.odoo16;
  };
  odoo17 = runTest {
    imports = [ ./odoo.nix ];
    _module.args.package = pkgs.odoo17;
  };
  oh-my-zsh = runTest ./oh-my-zsh.nix;
  oku = runTest ./oku.nix;
  olivetin = runTest ./olivetin.nix;
  ollama = runTest ./ollama.nix;
  ollama-cuda = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-cuda.nix;
  ollama-rocm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-rocm.nix;
  ollama-vulkan = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ollama-vulkan.nix;
  ombi = runTest ./ombi.nix;
  omnom = runTest ./omnom;
  oncall = runTest ./web-apps/oncall.nix;
  onlyoffice = runTest ./onlyoffice.nix;
  open-web-calendar = runTest ./web-apps/open-web-calendar.nix;
  open-webui = runTest ./open-webui.nix;
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
  openstack-image-metadata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).metadata or { };
  openstack-image-userdata =
    (handleTestOn [ "x86_64-linux" ] ./openstack-image.nix { }).userdata or { };
  opentabletdriver = runTest ./opentabletdriver.nix;
  opentelemetry-collector = runTest ./opentelemetry-collector.nix;
  openvscode-server = runTest ./openvscode-server.nix;
  openvswitch = runTest ./openvswitch.nix;
  optee = handleTestOn [ "aarch64-linux" ] ./optee.nix { };
  orangefs = runTest ./orangefs.nix;
  orthanc = runTest ./orthanc.nix;
  os-prober = handleTestOn [ "x86_64-linux" ] ./os-prober.nix { };
  osquery = handleTestOn [ "x86_64-linux" ] ./osquery.nix { };
  osrm-backend = runTest ./osrm-backend.nix;
  outline = runTest ./outline.nix;
  overlayfs = runTest ./overlayfs.nix;
  overseerr = runTest ./overseerr.nix;
  owi = runTest ./owi.nix;
  owncast = runTest ./owncast.nix;
  oxidized = handleTest ./oxidized.nix { };
  pacemaker = runTest ./pacemaker.nix;
  packagekit = runTest ./packagekit.nix;
  pairdrop = runTest ./web-apps/pairdrop.nix;
  paisa = runTest ./paisa.nix;
  pam-file-contents = runTest ./pam/pam-file-contents.nix;
  pam-lastlog = runTest ./pam/pam-lastlog.nix;
  pam-oath-login = runTest ./pam/pam-oath-login.nix;
  pam-u2f = runTest ./pam/pam-u2f.nix;
  pam-ussh = runTest ./pam/pam-ussh.nix;
  pam-zfs-key = runTest ./pam/zfs-key.nix;
  pangolin = runTest ./pangolin.nix;
  pantalaimon = runTest ./matrix/pantalaimon.nix;
  pantheon = runTest ./pantheon.nix;
  paperless = runTest ./paperless.nix;
  paretosecurity = runTest ./paretosecurity.nix;
  parsedmarc = handleTest ./parsedmarc { };
  pass-secret-service = runTest ./pass-secret-service.nix;
  password-option-override-ordering = runTest ./password-option-override-ordering.nix;
  patroni = handleTestOn [ "x86_64-linux" ] ./patroni.nix { };
  pdns-recursor = runTest ./pdns-recursor.nix;
  peerflix = runTest ./peerflix.nix;
  peering-manager = runTest ./web-apps/peering-manager.nix;
  peertube = handleTestOn [ "x86_64-linux" ] ./web-apps/peertube.nix { };
  pgadmin4 = runTest ./pgadmin4.nix;
  pgbackrest = import ./pgbackrest { inherit runTest; };
  pgbouncer = runTest ./pgbouncer.nix;
  pghero = runTest ./pghero.nix;
  pgmanage = runTest ./pgmanage.nix;
  pgweb = runTest ./pgweb.nix;
  phosh = runTest ./phosh.nix;
  photonvision = runTest ./photonvision.nix;
  photoprism = runTest ./photoprism.nix;
  php = import ./php/default.nix {
    inherit runTest;
    php = pkgs.php;
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
  pihole-ftl = import ./pihole-ftl { inherit runTest; };
  pingvin-share = runTest ./pingvin-share.nix;
  pinnwand = runTest ./pinnwand.nix;
  pixelfed = import ./web-apps/pixelfed { inherit runTestOn; };
  plantuml-server = runTest ./plantuml-server.nix;
  plasma6 = runTest ./plasma6.nix;
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
  postgres-websockets = runTest ./postgres-websockets.nix;
  postgresql = handleTest ./postgresql { };
  postgrest = runTest ./postgrest.nix;
  power-profiles-daemon = runTest ./power-profiles-daemon.nix;
  powerdns = runTest ./powerdns.nix;
  powerdns-admin = handleTest ./powerdns-admin.nix { };
  pppd = runTest ./pppd.nix;
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
  privatebin = runTest ./privatebin.nix;
  privoxy = runTest ./privoxy.nix;
  prometheus = import ./prometheus { inherit runTest; };
  prometheus-exporters = handleTest ./prometheus-exporters.nix { };
  prosody = runTest ./xmpp/prosody.nix;
  prosody-mysql = handleTest ./xmpp/prosody-mysql.nix { };
  prowlarr = runTest ./prowlarr.nix;
  proxy = runTest ./proxy.nix;
  pt2-clone = runTest ./pt2-clone.nix;
  public-inbox = runTest ./public-inbox.nix;
  pufferpanel = runTest ./pufferpanel.nix;
  pulseaudio = discoverTests (import ./pulseaudio.nix);
  pykms = runTest ./pykms.nix;
  pyload = runTest ./pyload.nix;
  qbittorrent = runTest ./qbittorrent.nix;
  qboot = handleTestOn [ "x86_64-linux" "i686-linux" ] ./qboot.nix { };
  qemu-vm-external-disk-image = runTest ./qemu-vm-external-disk-image.nix;
  qemu-vm-restrictnetwork = handleTest ./qemu-vm-restrictnetwork.nix { };
  qemu-vm-store = runTest ./qemu-vm-store.nix;
  qemu-vm-volatile-root = runTest ./qemu-vm-volatile-root.nix;
  qgis = handleTest ./qgis.nix { package = pkgs.qgis; };
  qgis-ltr = handleTest ./qgis.nix { package = pkgs.qgis-ltr; };
  qownnotes = runTest ./qownnotes.nix;
  qtile = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./qtile/default.nix;
  qtile-extras = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./qtile-extras/default.nix;
  quake3 = runTest ./quake3.nix;
  quicktun = runTest ./quicktun.nix;
  quickwit = runTest ./quickwit.nix;
  rabbitmq = runTest ./rabbitmq.nix;
  radarr = runTest ./radarr.nix;
  radicale = runTest ./radicale.nix;
  radicle = runTest ./radicle.nix;
  radicle-ci-broker = runTest ./radicle-ci-broker.nix;
  ragnarwm = runTestOn [ "x86_64-linux" "aarch64-linux" ] ./ragnarwm.nix;
  rasdaemon = runTest ./rasdaemon.nix;
  rathole = runTest ./rathole.nix;
  rauc = runTest ./rauc.nix;
  readarr = runTest ./readarr.nix;
  readeck = runTest ./readeck.nix;
  realm = runTest ./realm.nix;
  rebuilderd = runTest ./rebuilderd.nix;
  redis = handleTest ./redis.nix { };
  redlib = runTest ./redlib.nix;
  redmine = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./redmine.nix { };
  refind = runTest ./refind.nix;
  renovate = runTest ./renovate.nix;
  replace-dependencies = handleTest ./replace-dependencies { };
  reposilite = runTest ./reposilite.nix;
  restartByActivationScript = runTest ./restart-by-activation-script.nix;
  restic = runTest ./restic.nix;
  restic-rest-server = runTest ./restic-rest-server.nix;
  retroarch = runTest ./retroarch.nix;
  ringboard = runTest ./ringboard.nix;
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
  rsync = runTest ./rsync.nix;
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
  scaphandre = runTest ./scaphandre.nix;
  schleuder = runTest ./schleuder.nix;
  scion-freestanding-deployment = runTest ./scion/freestanding-deployment;
  scrutiny = runTest ./scrutiny.nix;
  scx = runTest ./scx/default.nix;
  sddm = import ./sddm.nix { inherit runTest; };
  sdl3 = runTest ./sdl3.nix;
  searx = runTest ./searx.nix;
  seatd = runTest ./seatd.nix;
  send = runTest ./send.nix;
  service-runner = runTest ./service-runner.nix;
  servo = runTest ./servo.nix;
  sftpgo = runTest ./sftpgo.nix;
  sfxr-qt = runTest ./sfxr-qt.nix;
  sgt-puzzles = runTest ./sgt-puzzles.nix;
  shadow = runTest ./shadow.nix;
  shadowsocks = handleTest ./shadowsocks { };
  shadps4 = runTest ./shadps4.nix;
  sharkey = runTest ./web-apps/sharkey.nix;
  shattered-pixel-dungeon = runTest ./shattered-pixel-dungeon.nix;
  shiori = runTest ./shiori.nix;
  signal-desktop = runTest ./signal-desktop.nix;
  silverbullet = runTest ./silverbullet.nix;
  simple = runTest ./simple.nix;
  sing-box = runTest ./sing-box.nix;
  sks = runTest ./sks.nix;
  slimserver = runTest ./slimserver.nix;
  slipshow = runTest ./slipshow.nix;
  slurm = runTest ./slurm.nix;
  smokeping = runTest ./smokeping.nix;
  snapcast = runTest ./snapcast.nix;
  snapper = runTest ./snapper.nix;
  snipe-it = runTest ./web-apps/snipe-it.nix;
  snips-sh = runTest ./snips-sh.nix;
  snmpd = runTest ./snmpd.nix;
  soapui = runTest ./soapui.nix;
  soft-serve = runTest ./soft-serve.nix;
  sogo = runTest ./sogo.nix;
  soju = runTest ./soju.nix;
  solanum = runTest ./solanum.nix;
  sonarr = runTest ./sonarr.nix;
  sonic-server = runTest ./sonic-server.nix;
  spacecookie = runTest ./spacecookie.nix;
  spark = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./spark { };
  spiped = runTest ./spiped.nix;
  sqlite3-to-mysql = runTest ./sqlite3-to-mysql.nix;
  squid = runTest ./squid.nix;
  ssh-agent-auth = runTest ./ssh-agent-auth.nix;
  ssh-audit = runTest ./ssh-audit.nix;
  sshwifty = runTest ./web-apps/sshwifty/default.nix;
  sslh = handleTest ./sslh.nix { };
  sssd-ldap = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd-ldap.nix { };
  sssd-legacy-config = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./sssd-legacy-config.nix { };
  stalwart-mail = runTest ./stalwart/stalwart-mail.nix;
  stargazer = runTest ./web-servers/stargazer.nix;
  starship = runTest ./starship.nix;
  startx = import ./startx.nix { inherit pkgs runTest; };
  stash = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stash.nix { };
  static-web-server = runTest ./web-servers/static-web-server.nix;
  step-ca = handleTestOn [ "x86_64-linux" ] ./step-ca.nix { };
  stratis = handleTest ./stratis { };
  strongswan-swanctl = runTest ./strongswan-swanctl.nix;
  stub-ld = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./stub-ld.nix { };
  stunnel = import ./stunnel.nix { inherit runTest; };
  sudo = runTest ./sudo.nix;
  sudo-rs = runTest ./sudo-rs.nix;
  sunshine = runTest ./sunshine.nix;
  suricata = runTest ./suricata.nix;
  suwayomi-server = import ./suwayomi-server.nix {
    inherit runTest;
    inherit (pkgs) lib;
  };
  svnserve = runTest ./svnserve.nix;
  swap-file-btrfs = runTest ./swap-file-btrfs.nix;
  swap-partition = runTest ./swap-partition.nix;
  swap-random-encryption = runTest ./swap-random-encryption.nix;
  swapspace = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./swapspace.nix { };
  sway = runTest ./sway.nix;
  swayfx = runTest ./swayfx.nix;
  switchTest = runTest ./switch-test.nix;
  sx = runTest ./sx.nix;
  sympa = runTest ./sympa.nix;
  syncthing = runTest ./syncthing/main.nix;
  syncthing-folders = runTest ./syncthing/folders.nix;
  syncthing-guiPassword = runTest ./syncthing/guiPassword.nix;
  syncthing-guiPasswordFile = runTest ./syncthing/guiPasswordFile.nix;
  syncthing-init = runTest ./syncthing/init.nix;
  # FIXME: Test has been failing since 2025-07-06:
  # https://github.com/NixOS/nixpkgs/issues/447674
  # syncthing-many-devices = runTest ./syncthing/many-devices.nix;
  syncthing-no-settings = runTest ./syncthing/no-settings.nix;
  syncthing-relay = runTest ./syncthing/relay.nix;
  sysfs = runTest ./sysfs.nix;
  sysinit-reactivation = runTest ./sysinit-reactivation.nix;
  systemd = runTest ./systemd.nix;
  systemd-analyze = runTest ./systemd-analyze.nix;
  systemd-binfmt = handleTestOn [ "x86_64-linux" ] ./systemd-binfmt.nix { };
  systemd-boot = import ./systemd-boot.nix { inherit runTest runTestOn; };
  systemd-bpf = runTest ./systemd-bpf.nix;
  systemd-capsules = runTest ./systemd-capsules.nix;
  systemd-confinement = handleTest ./systemd-confinement { };
  systemd-coredump = runTest ./systemd-coredump.nix;
  systemd-credentials-tpm2 = runTest ./systemd-credentials-tpm2.nix;
  systemd-cryptenroll = runTest ./systemd-cryptenroll.nix;
  systemd-escaping = runTest ./systemd-escaping.nix;
  systemd-homed = runTest ./systemd-homed.nix;
  systemd-initrd-bridge = runTest ./systemd-initrd-bridge.nix;
  systemd-initrd-btrfs-raid = runTest ./systemd-initrd-btrfs-raid.nix;
  systemd-initrd-credentials = runTest ./systemd-initrd-credentials.nix;
  systemd-initrd-luks-empty-passphrase = runTest {
    imports = [ ./initrd-luks-empty-passphrase.nix ];
    _module.args.systemdStage1 = true;
  };
  systemd-initrd-luks-fido2 = runTest ./systemd-initrd-luks-fido2.nix;
  systemd-initrd-luks-keyfile = runTest ./systemd-initrd-luks-keyfile.nix;
  systemd-initrd-luks-password = runTest ./systemd-initrd-luks-password.nix;
  systemd-initrd-luks-tpm2 = runTest ./systemd-initrd-luks-tpm2.nix;
  systemd-initrd-luks-unl0kr = runTest ./systemd-initrd-luks-unl0kr.nix;
  systemd-initrd-modprobe = runTest ./systemd-initrd-modprobe.nix;
  systemd-initrd-networkd = import ./systemd-initrd-networkd.nix { inherit runTest; };
  systemd-initrd-networkd-openvpn = handleTestOn [
    "x86_64-linux"
    "i686-linux"
  ] ./initrd-network-openvpn { systemdStage1 = true; };
  systemd-initrd-networkd-ssh = runTest ./systemd-initrd-networkd-ssh.nix;
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
  systemd-misc = runTest ./systemd-misc.nix;
  systemd-networkd = runTest ./systemd-networkd.nix;
  systemd-networkd-batadv = runTest ./systemd-networkd-batadv.nix;
  systemd-networkd-bridge = runTest ./systemd-networkd-bridge.nix;
  systemd-networkd-dhcpserver = runTest ./systemd-networkd-dhcpserver.nix;
  systemd-networkd-dhcpserver-static-leases = runTest ./systemd-networkd-dhcpserver-static-leases.nix;
  systemd-networkd-ipv6-prefix-delegation =
    handleTest ./systemd-networkd-ipv6-prefix-delegation.nix
      { };
  systemd-networkd-vrf = runTest ./systemd-networkd-vrf.nix;
  systemd-no-tainted = runTest ./systemd-no-tainted.nix;
  systemd-nspawn = runTest ./systemd-nspawn.nix;
  systemd-nspawn-configfile = runTest ./systemd-nspawn-configfile.nix;
  systemd-oomd = runTest ./systemd-oomd.nix;
  systemd-portabled = runTest ./systemd-portabled.nix;
  systemd-pstore = runTest ./systemd-pstore.nix;
  systemd-repart = handleTest ./systemd-repart.nix { };
  systemd-resolved = runTest ./systemd-resolved.nix;
  systemd-resolved-dnssd = runTest ./systemd-resolved-dnssd.nix;
  systemd-shutdown = runTest ./systemd-shutdown.nix;
  systemd-ssh-proxy = runTest ./systemd-ssh-proxy.nix;
  systemd-sysupdate = runTest ./systemd-sysupdate.nix;
  systemd-sysusers-immutable = runTest ./systemd-sysusers-immutable.nix;
  systemd-sysusers-mutable = runTest ./systemd-sysusers-mutable.nix;
  systemd-sysusers-password-option-override-ordering = runTest ./systemd-sysusers-password-option-override-ordering.nix;
  systemd-timesyncd-nscd-dnssec = runTest ./systemd-timesyncd-nscd-dnssec.nix;
  systemd-user-linger = runTest ./systemd-user-linger.nix;
  systemd-user-linger-purge = runTest ./systemd-user-linger-purge.nix;
  systemd-user-tmpfiles-rules = runTest ./systemd-user-tmpfiles-rules.nix;
  systemd-userdbd = runTest ./systemd-userdbd.nix;
  systemtap = handleTest ./systemtap.nix { };
  szurubooru = handleTest ./szurubooru.nix { };
  taler = handleTest ./taler { };
  tandoor-recipes = runTest ./tandoor-recipes.nix;
  tandoor-recipes-script-name = runTest ./tandoor-recipes-script-name.nix;
  tang = runTest ./tang.nix;
  taskchampion-sync-server = runTest ./taskchampion-sync-server.nix;
  taskserver = runTest ./taskserver.nix;
  tayga = runTest ./tayga.nix;
  technitium-dns-server = runTest ./technitium-dns-server.nix;
  teeworlds = runTest ./teeworlds.nix;
  telegraf = runTest ./telegraf.nix;
  teleport = handleTest ./teleport.nix { };
  teleports = runTest ./teleports.nix;
  temporal = runTest ./temporal.nix;
  terminal-emulators = handleTest ./terminal-emulators.nix { };
  thanos = runTest ./thanos.nix;
  thelounge = handleTest ./thelounge.nix { };
  tiddlywiki = runTest ./tiddlywiki.nix;
  tigervnc = handleTest ./tigervnc.nix { };
  tika = runTest ./tika.nix;
  timezone = runTest ./timezone.nix;
  timidity = handleTestOn [ "aarch64-linux" "x86_64-linux" ] ./timidity { };
  tinc = handleTest ./tinc { };
  tinydns = runTest ./tinydns.nix;
  tinyproxy = runTest ./tinyproxy.nix;
  tinywl = runTest ./tinywl.nix;
  tlsrpt = runTest ./tlsrpt.nix;
  tmate-ssh-server = runTest ./tmate-ssh-server.nix;
  tomcat = runTest ./tomcat.nix;
  tor = runTest ./tor.nix;
  tpm-ek = handleTest ./tpm-ek { };
  tpm2 = runTest ./tpm2.nix;
  traccar = runTest ./traccar.nix;
  # tracee requires bpf
  tracee = handleTestOn [ "x86_64-linux" ] ./tracee.nix { };
  traefik = runTestOn [ "aarch64-linux" "x86_64-linux" ] ./traefik.nix;
  trafficserver = runTest ./trafficserver.nix;
  transfer-sh = runTest ./transfer-sh.nix;
  transmission_4 = handleTest ./transmission.nix { };
  trezord = runTest ./trezord.nix;
  trickster = runTest ./trickster.nix;
  trilium-server = runTestOn [ "x86_64-linux" ] ./trilium-server.nix;
  tsm-client-gui = runTest ./tsm-client-gui.nix;
  ttyd = runTest ./web-servers/ttyd.nix;
  tuliprox = runTest ./tuliprox.nix;
  tuned = runTest ./tuned.nix;
  tuptime = runTest ./tuptime.nix;
  turbovnc-headless-server = runTest ./turbovnc-headless-server.nix;
  turn-rs = runTest ./turn-rs.nix;
  tusd = runTest ./tusd/default.nix;
  tuxguitar = runTest ./tuxguitar.nix;
  twingate = runTest ./twingate.nix;
  txredisapi = runTest ./txredisapi.nix;
  typesense = runTest ./typesense.nix;
  tzupdate = runTest ./tzupdate.nix;
  ucarp = runTest ./ucarp.nix;
  udisks2 = runTest ./udisks2.nix;
  ulogd = runTest ./ulogd/ulogd.nix;
  umami = runTest ./web-apps/umami.nix;
  umurmur = runTest ./umurmur.nix;
  unbound = runTest ./unbound.nix;
  unifi = runTest ./unifi.nix;
  unit-perl = runTest ./web-servers/unit-perl.nix;
  unit-php = runTest ./web-servers/unit-php.nix;
  upnp.iptables = handleTest ./upnp.nix { useNftables = false; };
  upnp.nftables = handleTest ./upnp.nix { useNftables = true; };
  uptermd = runTest ./uptermd.nix;
  uptime-kuma = runTest ./uptime-kuma.nix;
  urn-timer = runTest ./urn-timer.nix;
  usbguard = runTest ./usbguard.nix;
  user-activation-scripts = runTest ./user-activation-scripts.nix;
  user-enable-option = runTest ./user-enable-option.nix;
  user-expiry = runTest ./user-expiry.nix;
  user-home-mode = runTest ./user-home-mode.nix;
  userborn = runTest ./userborn.nix;
  userborn-immutable-etc = runTest ./userborn-immutable-etc.nix;
  userborn-immutable-users = runTest ./userborn-immutable-users.nix;
  userborn-mutable-etc = runTest ./userborn-mutable-etc.nix;
  userborn-mutable-users = runTest ./userborn-mutable-users.nix;
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
  vector = import ./vector { inherit runTest; };
  velocity = runTest ./velocity.nix;
  vengi-tools = runTest ./vengi-tools.nix;
  victorialogs = import ./victorialogs { inherit runTest; };
  victoriametrics = import ./victoriametrics { inherit runTest; };
  victoriatraces = import ./victoriatraces { inherit runTest; };
  vikunja = runTest ./vikunja.nix;
  virtualbox = handleTestOn [ "x86_64-linux" ] ./virtualbox.nix { };
  vm-variant = handleTest ./vm-variant.nix { };
  vscode-remote-ssh = handleTestOn [ "x86_64-linux" ] ./vscode-remote-ssh.nix { };
  vscodium = import ./vscodium.nix { inherit runTest; };
  vsftpd = runTest ./vsftpd.nix;
  waagent = runTest ./waagent.nix;
  wakapi = runTest ./wakapi.nix;
  warpgate = runTest ./warpgate.nix;
  warzone2100 = runTest ./warzone2100.nix;
  wasabibackend = runTest ./wasabibackend.nix;
  wastebin = runTest ./wastebin.nix;
  watchdogd = runTest ./watchdogd.nix;
  webhook = runTest ./webhook.nix;
  weblate = runTest ./web-apps/weblate.nix;
  wg-access-server = runTest ./wg-access-server.nix;
  whisparr = runTest ./whisparr.nix;
  whoami = runTest ./whoami.nix;
  whoogle-search = runTest ./whoogle-search.nix;
  wiki-js = runTest ./wiki-js.nix;
  windmill = import ./windmill {
    inherit pkgs runTest;
    inherit (pkgs) lib;
  };
  wine = handleTest ./wine.nix { };
  wireguard = import ./wireguard {
    inherit pkgs runTest;
    inherit (pkgs) lib;
  };
  without-nix = runTest ./without-nix.nix;
  wmderland = runTest ./wmderland.nix;
  wordpress = runTest ./wordpress.nix;
  workout-tracker = runTest ./workout-tracker.nix;
  wpa_supplicant = import ./wpa_supplicant.nix { inherit pkgs runTest; };
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
  ydotool = import ./ydotool.nix {
    inherit (pkgs) lib;
    inherit runTest;
  };
  yggdrasil = runTest ./yggdrasil.nix;
  your_spotify = runTest ./your_spotify.nix;
  zammad = runTest ./zammad.nix;
  zenohd = runTest ./zenohd.nix;
  zeronet-conservancy = runTest ./zeronet-conservancy.nix;
  zfs = handleTest ./zfs.nix { };
  zigbee2mqtt = runTest ./zigbee2mqtt.nix;
  zipline = runTest ./zipline.nix;
  zoneminder = runTest ./zoneminder.nix;
  zookeeper = runTest ./zookeeper.nix;
  zoom-us = runTest ./zoom-us.nix;
  zram-generator = runTest ./zram-generator.nix;
  zrepl = runTest ./zrepl.nix;
  zwave-js = runTest ./zwave-js.nix;
  zwave-js-ui = runTest ./zwave-js-ui.nix;
  # keep-sorted end
}
