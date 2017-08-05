lib: with (import ./param-constructors.nix lib);

let loglevelParams = import ./strongswan-loglevel-params.nix lib;
in {
  accept_unencrypted_mainmode_messages = mkYesNoParam no ''
    Accept unencrypted ID and HASH payloads in IKEv1 Main Mode. Some
    implementations send the third Main Mode message unencrypted, probably
    to find the PSKs for the specified ID for authentication. This is very
    similar to Aggressive Mode, and has the same security implications: A
    passive attacker can sniff the negotiated Identity, and start brute
    forcing the PSK using the HASH payload. It is recommended to keep this
    option to no, unless you know exactly what the implications are and
    require compatibility to such devices (for example, some SonicWall
    boxes).
  '';

  block_threshold = mkIntParam 5 ''
    Maximum number of half-open IKE_SAs for a single peer IP.
  '';

  cache_crls = mkYesNoParam no ''
    Whether Certicate Revocation Lists (CRLs) fetched via HTTP or LDAP
    should be saved under a unique file name derived from the public
    key of the Certification Authority (CA) to
    <literal>/etc/ipsec.d/crls</literal> (stroke) or
    <literal>/etc/swanctl/x509crl</literal> (vici), respectively.
  '';

  cert_cache = mkYesNoParam yes ''
    Whether relations in validated certificate chains should be cached in memory.
  '';

  cisco_unity = mkYesNoParam no ''
    Send Cisco Unity vendor ID payload (IKEv1 only), see unity plugin.
  '';

  close_ike_on_child_failure = mkYesNoParam no ''
    Close the IKE_SA if setup of the CHILD_SA along with IKE_AUTH failed.
  '';

  cookie_threshold = mkIntParam 10 ''
    Number of half-open IKE_SAs that activate the cookie mechanism.
  '';

  crypto_test.bench = mkYesNoParam no ''
    Benchmark crypto algorithms and order them by efficiency.
  '';

  crypto_test.bench_size = mkIntParam 1024 ''
    Buffer size used for crypto benchmark.
  '';

  crypto_test.bench_time = mkIntParam 50 ''
    Number of iterations to test each algorithm.
  '';

  crypto_test.on_add = mkYesNoParam no ''
    Test crypto algorithms during registration
    (requires test vectors provided by the test-vectors plugin).
  '';

  crypto_test.on_create = mkYesNoParam no ''
    Test crypto algorithms on each crypto primitive instantiation.
  '';

  crypto_test.required = mkYesNoParam no ''
    Strictly require at least one test vector to enable an algorithm.
  '';

  crypto_test.rng_true = mkYesNoParam no ''
    Whether to test RNG with TRUE quality; requires a lot of entropy.
  '';

  delete_rekeyed = mkYesNoParam no ''
    Delete CHILD_SAs right after they got successfully rekeyed (IKEv1 only).
    Reduces the number of stale CHILD_SAs in scenarios with a lot of rekeyings.
    However, this might cause problems with implementations that continue
    to use rekeyed SAs until they expire.
  '';

  delete_rekeyed_delay = mkIntParam 5 ''
    Delay in seconds until inbound IPsec SAs are deleted after rekeyings
    (IKEv2 only).
    </para><para>
    To process delayed packets the inbound part of a CHILD_SA is kept
    installed up to the configured number of seconds after it got replaced
    during a rekeying. If set to 0 the CHILD_SA will be kept installed until
    it expires (if no lifetime is set it will be destroyed immediately).
  '';

  dh_exponent_ansi_x9_42 = mkYesNoParam yes ''
    Use ANSI X9.42 DH exponent size or optimum size matched to
    cryptographical strength.
  '';

  dlopen_use_rtld_now = mkYesNoParam no ''
    Use RTLD_NOW with dlopen() when loading plugins and IMV/IMCs to reveal
    missing symbols immediately. Useful during development of custom plugins.
  '';

  dns1 = mkOptionalStrParam ''
    DNS server assigned to peer via configuration payload (CP), see attr plugin.
  '';

  dns2 = mkOptionalStrParam ''
    DNS server assigned to peer via configuration payload (CP).
  '';

  dos_protection = mkYesNoParam yes ''
    Enable Denial of Service protection using cookies and aggressiveness checks.
  '';

  ecp_x_coordinate_only = mkYesNoParam yes ''
    Compliance with the errata for RFC 4753.
  '';

  filelog = mkAttrsOfParams ({
    append = mkYesNoParam yes ''
      If this option is enabled log entries are appended to the existing file.
    '';

    flush_line = mkYesNoParam no ''
      Enabling this option disables block buffering and enables line
      buffering. That is, a flush to disk is enforced for each logged line.
    '';

    ike_name = mkYesNoParam no ''
      Prefix each log entry with the connection name and a unique numerical
      identifier for each IKE_SA.
    '';

    time_format = mkOptionalStrParam ''
      Prefix each log entry with a timestamp. The option accepts a format string
      as passed to strftime(3).
    '';

    time_add_ms = mkYesNoParam no ''
      Adds the milliseconds within the current second after the timestamp
      (separated by a dot, so time_format should end with %S or %T)
    '';
  } // loglevelParams) ''Section to define file loggers, see LoggerConfiguration.'';

  flush_auth_cfg = mkYesNoParam no ''
    If enabled objects used during authentication (certificates, identities
    etc.) are released to free memory once an IKE_SA is
    established. Enabling this might conflict with plugins that later need
    access to e.g. the used certificates.
  '';

  follow_redirects = mkYesNoParam yes ''
    Whether to follow IKEv2 redirects (RFC 5685).
  '';

  fragment_size = mkIntParam 1280 ''
    Maximum size (complete IP datagram size in bytes) of a sent IKE fragment
    when using proprietary IKEv1 or standardized IKEv2 fragmentation,
    defaults to 1280 (use 0 for address family specific default values,
    which uses a lower value for IPv4). If specified this limit is used for
    both IPv4 and IPv6.
  '';

  group = mkOptionalStrParam ''
    Name of the group the daemon changes to after startup.
  '';

  half_open_timeout = mkIntParam 30 ''
    Timeout in seconds for connecting IKE_SAs, also see IKE_SA_INIT dropping.
  '';

  hash_and_url = mkYesNoParam no ''
    Enable hash and URL support.
  '';

  host_resolver.max_threads = mkIntParam 3 ''
    Maximum number of concurrent resolver threads (they are terminated if unused).
  '';

  host_resolver.min_threads = mkIntParam 0 ''
    Minimum number of resolver threads to keep around.
  '';

  i_dont_care_about_security_and_use_aggressive_mode_psk = mkYesNoParam no ''
    If enabled responders are allowed to use IKEv1 Aggressive Mode with
    pre-shared keys, which is discouraged due to security concerns (offline
    attacks on the openly transmitted hash of the PSK).
  '';

  ignore_acquire_ts = mkYesNoParam no ''
    If this is disabled the traffic selectors from the kernel's acquire
    events, which are derived from the triggering packet, are prepended to
    the traffic selectors from the configuration for IKEv2 connection. By
    enabling this, such specific traffic selectors will be ignored and only
    the ones in the config will be sent. This always happens for IKEv1
    connections as the protocol only supports one set of traffic selectors
    per CHILD_SA.
  '';

  ignore_routing_tables = mkSpaceSepListParam [] ''
    A space-separated list of routing tables to be excluded from route lookup.
  '';

  ikesa_limit = mkIntParam 0 ''
    Maximum number of IKE_SAs that can be established at the same time
    before new connection attempts are blocked.
  '';

  ikesa_table_segments = mkIntParam 1 ''
    Number of exclusively locked segments in the hash table, see IKE_SA
    lookup tuning.
  '';

  ikesa_table_size = mkIntParam 1 ''
    Size of the IKE_SA hash table, see IKE_SA lookup tuning.
  '';

  inactivity_close_ike = mkYesNoParam no ''
    Whether to close IKE_SA if the only CHILD_SA closed due to inactivity.
  '';

  init_limit_half_open = mkIntParam 0 ''
    Limit new connections based on the current number of half open IKE_SAs,
    see IKE_SA_INIT dropping.
  '';

  init_limit_job_load = mkIntParam 0 ''
    Limit new connections based on the number of jobs currently queued for
    processing, see IKE_SA_INIT dropping.
  '';

  initiator_only = mkYesNoParam no ''
    Causes charon daemon to ignore IKE initiation requests.
  '';

  install_routes = mkYesNoParam yes ''
    Install routes into a separate routing table for established IPsec
    tunnels. If disabled a more efficient lookup for source and next-hop
    addresses is used since 5.5.2.
  '';

  install_virtual_ip = mkYesNoParam yes ''
    Install virtual IP addresses.
  '';

  install_virtual_ip_on = mkOptionalStrParam ''
    The name of the interface on which virtual IP addresses should be
    installed. If not specified the addresses will be installed on the
    outbound interface.
  '';

  integrity_test = mkYesNoParam no ''
    Check daemon, libstrongswan and plugin integrity at startup.
  '';

  interfaces_ignore = mkCommaSepListParam [] ''
    List of network interfaces that should be ignored, if
    <option>interfaces_use</option> is specified this option has no effect.
  '';

  interfaces_use = mkCommaSepListParam [] ''
    List of network interfaces that should be used by
    charon. All other interfaces are ignored.
  '';

  keep_alive = mkIntParam 20 ''
    NAT keep alive interval in seconds.
  '';

  leak_detective.detailed = mkYesNoParam yes ''
    Includes source file names and line numbers in leak detective output.
  '';

  leak_detective.usage_threshold = mkIntParam 10240 ''
    Threshold in bytes for leaks to be reported (0 to report all).
  '';

  leak_detective.usage_threshold_count = mkIntParam 0 ''
    Threshold in number of allocations for leaks to be reported (0 to report
    all).
  '';

  load = mkSpaceSepListParam [] ''
    Plugins to load in IKEv2 charon daemon, see PluginLoad.
  '';

  load_modular = mkYesNoParam no ''
    If enabled the list of plugins to load is determined by individual load
    settings for each plugin, see PluginLoad.
  '';

  make_before_break = mkYesNoParam no ''
    Initiate IKEv2 reauthentication with a make-before-break instead of a
    break-before-make scheme. Make-before-break uses overlapping IKE and
    CHILD_SA during reauthentication by first recreating all new SAs before
    deleting the old ones. This behavior can be beneficial to avoid
    connectivity gaps during reauthentication, but requires support for
    overlapping SAs by the peer. strongSwan can handle such overlapping SAs
    since 5.3.0.
  '';

  max_ikev1_exchanges = mkIntParam 3 ''
    Maximum number of IKEv1 phase 2 exchanges per IKE_SA to keep state about
    and track concurrently.
  '';

  max_packet = mkIntParam 10000 ''
    Maximum packet size accepted by charon.
  '';

  multiple_authentication = mkYesNoParam yes ''
    Enable multiple authentication exchanges (RFC 4739).
  '';

  nbns1 = mkOptionalStrParam ''
    WINS server assigned to peer via configuration payload (CP), see attr
    plugin.
  '';

  nbns2 = mkOptionalStrParam ''
    WINS server assigned to peer via configuration payload (CP).
  '';

  port = mkIntParam 500 ''
    UDP port used locally. If set to 0 a random port will be allocated.
  '';

  port_nat_t = mkIntParam 4500 ''
    UDP port used locally in case of NAT-T. If set to 0 a random port will
    be allocated. Has to be different from charon.port, otherwise a random
    port will be allocated.
  '';

  prefer_best_path = mkYesNoParam no ''
    By default, charon keeps SAs on the routing path with addresses it
    previously used if that path is still usable. By enabling this option,
    it tries more aggressively to update SAs with MOBIKE on routing priority
    changes using the cheapest path. This adds more noise, but allows to
    dynamically adapt SAs to routing priority changes. This option has no
    effect if MOBIKE is not supported or disabled.
  '';

  prefer_configured_proposals = mkYesNoParam yes ''
    Prefer locally configured proposals for IKE/IPsec over supplied ones as
    responder (disabling this can avoid keying retries due to
    INVALID_KE_PAYLOAD notifies).
  '';

  prefer_temporary_addrs = mkYesNoParam no ''
    By default public IPv6 addresses are preferred over temporary ones
    (according to RFC 4941), to make connections more stable. Enable this
    option to reverse this.
  '';

  process_route = mkYesNoParam yes ''
    Process RTM_NEWROUTE and RTM_DELROUTE events.
  '';

  processor.priority_threads = {
    critical = mkIntParam 0 ''
      Threads reserved for CRITICAL priority class jobs.
    '';

    high = mkIntParam 0 ''
      Threads reserved for HIGH priority class jobs.
    '';

    medium = mkIntParam 0 ''
      Threads reserved for MEDIUM priority class jobs.
    '';

    low = mkIntParam 0 ''
      Threads reserved for LOW priority class jobs.
    '';
  };

  receive_delay = mkIntParam 0 ''
    Delay in ms for receiving packets, to simulate larger RTT.
  '';

  receive_delay_response = mkYesNoParam yes ''
    Delay response messages.
  '';

  receive_delay_request = mkYesNoParam yes ''
    Delay request messages.
  '';

  receive_delay_type = mkIntParam 0 ''
    Specific IKEv2 message type to delay, 0 for any.
  '';

  replay_window = mkIntParam 32 ''
    Size of the AH/ESP replay window, in packets.
  '';

  retransmit_base = mkFloatParam "1.8" ''
    Base to use for calculating exponential back off, see Retransmission.
  '';

  retransmit_jitter = mkIntParam 0 ''
    Maximum jitter in percent to apply randomly to calculated retransmission
    timeout (0 to disable).
  '';

  retransmit_limit = mkIntParam 0 ''
    Upper limit in seconds for calculated retransmission timeout (0 to
    disable).
  '';

  retransmit_timeout = mkFloatParam "4.0" ''
    Timeout in seconds before sending first retransmit.
  '';

  retransmit_tries = mkIntParam 5 ''
    Number of times to retransmit a packet before giving up.
  '';

  retry_initiate_interval = mkIntParam 0 ''
    Interval in seconds to use when retrying to initiate an IKE_SA (e.g. if
    DNS resolution failed), 0 to disable retries.
  '';

  reuse_ikesa = mkYesNoParam yes ''
    Initiate CHILD_SA within existing IKE_SAs (always enabled for IKEv1).
  '';

  routing_table = mkIntParam 220 ''
    Numerical routing table to install routes to.
  '';

  routing_table_prio = mkIntParam 220 ''
    Priority of the routing table.
  '';

  send_delay = mkIntParam 0 ''
    Delay in ms for sending packets, to simulate larger RTT.
  '';

  send_delay_request = mkYesNoParam yes ''
    Delay request messages.
  '';

  send_delay_response = mkYesNoParam yes ''
    Delay response messages.
  '';

  send_delay_type = mkIntParam 0 ''
    Specific IKEv2 message type to delay, 0 for any.
  '';

  send_vendor_id = mkYesNoParam no ''
    Send strongSwan vendor ID payload.
  '';

  signature_authentication = mkYesNoParam yes ''
    Whether to enable Signature Authentication as per RFC 7427.
  '';

  signature_authentication_constraints = mkYesNoParam yes ''
    If enabled, signature schemes configured in rightauth, in addition to
    getting used as constraints against signature schemes employed in the
    certificate chain, are also used as constraints against the signature
    scheme used by peers during IKEv2.
  '';

  spi_min = mkHexParam "0xc0000000" ''
    The lower limit for SPIs requested from the kernel for IPsec SAs. Should
    not be set lower than 0x00000100 (256), as SPIs between 1 and 255 are
    reserved by IANA.
  '';

  spi_max = mkHexParam "0xcfffffff" ''
    The upper limit for SPIs requested from the kernel for IPsec SAs.
  '';

  start-scripts = mkAttrsOfParam (mkStrParam "" "") ''
    Section containing a list of scripts (name = path) that are executed
    when the daemon is started.
  '';

  stop-scripts = mkAttrsOfParam (mkStrParam "" "") ''
    Section containing a list of scripts (name = path) that are executed
    when the daemon is terminated.
  '';

  syslog = loglevelParams // {
    identifier = mkOptionalStrParam ''
      Identifier for use with openlog(3).
      </para><para>
      Global identifier used for an openlog(3) call, prepended to each log
      message by syslog.  If not configured, openlog(3) is not called, so
      the value will depend on system defaults (often the program name).
    '';

    ike_name = mkYesNoParam no ''
      Prefix each log entry with the connection name and a unique numerical
      identifier for each IKE_SA.
    '';
  };

  threads = mkIntParam 16 ''
    Number of worker threads in charon. Several of these are reserved for
    long running tasks in internal modules and plugins. Therefore, make sure
    you don't set this value too low. The number of idle worker threads
    listed in ipsec statusall might be used as indicator on the number of
    reserved threads (JobPriority has more on this).
  '';

  user = mkOptionalStrParam ''
    Name of the user the daemon changes to after startup.
  '';

  x509.enforce_critical = mkYesNoParam yes ''
    Discard certificates with unsupported or unknown critical extensions.
  '';

  plugins = import ./strongswan-charon-plugins-params.nix lib;

  imcv = {
    assessment_result = mkYesNoParam yes ''
      Whether IMVs send a standard IETF Assessment Result attribute.
    '';

    database = mkOptionalStrParam ''
      Global IMV policy database URI. If it contains a password, make sure to
      adjust the permissions of the config file accordingly.
    '';

    os_info.default_password_enabled = mkYesNoParam no ''
      Manually set whether a default password is enabled.
    '';

    os_info.name = mkOptionalStrParam ''
      Manually set the name of the client OS (e.g. <literal>NixOS</literal>).
    '';

    os_info.version = mkOptionalStrParam ''
      Manually set the version of the client OS (e.g. <literal>17.09</literal>).
    '';

    policy_script = mkStrParam "ipsec _imv_policy" ''
      Script called for each TNC connection to generate IMV policies.
    '';
  };

  tls = {
    cipher = mkSpaceSepListParam [] ''
      List of TLS encryption ciphers.
    '';

    key_exchange = mkSpaceSepListParam [] ''
      List of TLS key exchange methods.
    '';

    mac = mkSpaceSepListParam [] ''
      List of TLS MAC algorithms.
    '';

    suites = mkSpaceSepListParam [] ''
      List of TLS cipher suites.
    '';
  };

  tnc = {
    libtnccs.tnc_config = mkStrParam "/etc/tnc_config" ''
      TNC IMC/IMV configuration file.
    '';
  };
}
