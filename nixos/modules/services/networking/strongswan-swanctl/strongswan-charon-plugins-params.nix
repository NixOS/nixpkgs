lib : with (import ./param-constructors.nix lib); {
  addrblock.strict = mkYesNoParam yes ''
    If enabled, a subject certificate without an RFC 3779 address block
    extension is rejected if the issuer certificate has such an addrblock
    extension. If disabled, subject certificates issued without addrblock
    extension are accepted without any traffic selector checks and no policy
    is enforced by the plugin.
  '';

  android_log.loglevel = mkIntParam 1 ''
    Loglevel for logging to Android specific logger.
  '';

  attr = mkAttrsOfParam (mkCommaSepListParam [] "") ''
    Section to specify arbitrary attributes that are assigned to a peer
    via configuration payload, see attr plugin.
    </para><para>
    The attribute can be either
    <literal>address</literal>,
    <literal>netmask</literal>,
    <literal>dns</literal>,
    <literal>nbns</literal>,
    <literal>dhcp</literal>,
    <literal>subnet</literal>,
    <literal>split-include</literal>,
    <literal>split-exclude</literal>
    or the numeric identifier of the attribute type. The assigned value can be
    an IPv4/IPv6 address, a subnet in CIDR notation or an arbitrary value
    depending on the attribute type. Since some attribute types accept multiple
    values all values must be specified as a list.
  '';

  attr-sql.crash_recovery = mkYesNoParam yes ''
    Release all online leases during startup. Disable this to share the DB
    between multiple VPN gateways.
  '';

  attr-sql.database  = mkOptionalStrParam ''
    Database URI for attr-sql plugin used by charon. If it contains a
    password, make sure to adjust the permissions of the config file
    accordingly.
  '';

  attr-sql.lease_history = mkYesNoParam yes ''
    Enable logging of SQL IP pool leases.
  '';

  bliss.use_bliss_b = mkYesNoParam yes ''
    Use the enhanced BLISS-B key generation and signature algorithm.
  '';

  bypass-lan.interfaces_ignore = mkCommaSepListParam [] ''
    List of network interfaces for which connected subnets
    should be ignored, if interfaces_use is specified this option has no
    effect.
  '';

  bypass-lan.interfaces_use = mkCommaSepListParam [] ''
    List of network interfaces for which connected subnets
    should be considered. All other interfaces are ignored.
  '';

  certexpire.csv.cron = mkOptionalStrParam ''
    Cron style string specifying CSV export times, see certexpire for
    details.
  '';

  certexpire.csv.empty_string = mkOptionalStrParam ''
    String to use in empty intermediate CA fields.
  '';

  certexpire.csv.fixed_fields = mkYesNoParam yes ''
    Use a fixed intermediate CA field count.
  '';

  certexpire.csv.force = mkYesNoParam yes ''
    Force export of all trustchains we have a private key for.
  '';

  certexpire.csv.format = mkStrParam "%d:%m:%Y" ''
    strftime(3) format string to export expiration dates as.
  '';

  certexpire.csv.local = mkOptionalStrParam ''
    strftime(3) format string for the CSV file name to export local
    certificates to.
  '';

  certexpire.csv.remote = mkOptionalStrParam ''
    strftime(3) format string for the CSV file name to export remote
    certificates to.
  '';

  certexpire.csv.separator = mkStrParam "," ''
    CSV field separator.
  '';

  coupling.file = mkOptionalStrParam ''
    File to store coupling list to, see certcoupling plugin for details.
  '';

  coupling.hash = mkStrParam "sha1" ''
    Hashing algorithm to fingerprint coupled certificates.
  '';

  coupling.max = mkIntParam 1 ''
    Maximum number of coupling entries to create.
  '';

  curl.redir = mkIntParam (-1) ''
    Maximum number of redirects followed by the plugin, set to 0 to disable
    following redirects, set to -1 for no limit.
  '';

  dhcp.force_server_address = mkYesNoParam no ''
    Always use the configured server address, see DHCP plugin for details.
  '';

  dhcp.identity_lease = mkYesNoParam no ''
    Derive user-defined MAC address from hash of IKEv2 identity.
  '';

  dhcp.interface = mkOptionalStrParam ''
    Interface name the plugin uses for address allocation. The default is to
    bind to any and let the system decide which way to route the packets to
    the DHCP server.
  '';

  dhcp.server = mkStrParam "255.255.255.255" ''
    DHCP server unicast or broadcast IP address.
  '';

  dnscert.enable = mkYesNoParam no ''
    Enable fetching of CERT RRs via DNS.
  '';

  duplicheck.enable = mkYesNoParam yes ''
    Enable duplicheck plugin (if loaded).
  '';

  duplicheck.socket = mkStrParam "unix://\${piddir}/charon.dck" ''
    Socket provided by the duplicheck plugin.
  '';

  eap-aka.request_identity = mkYesNoParam yes "";

  eap-aka-3ggp2.seq_check = mkOptionalStrParam ''
    Enable to activate sequence check of the AKA SQN values in order to trigger
    resync cycles.
  '';

  eap-dynamic.prefer_user = mkYesNoParam no ''
    If enabled, the eap-dynamic plugin will prefer the order of the EAP
    methods in an EAP-Nak message sent by a client over the one configured
    locally.
  '';

  eap-dynamic.preferred = mkCommaSepListParam [] ''
    The preferred EAP method(s) to be used by the eap-dynamic plugin. If it is
    not set, the first registered method will be used initially. The methods
    are tried in the given order before trying the rest of the registered
    methods.
  '';

  eap-gtc.backend = mkStrParam "pam" ''
    XAuth backend to be used for credential verification, see EAP-GTC.
  '';

  eap-peap.fragment_size = mkIntParam 1024 ''
    Maximum size of an EAP-PEAP packet.
  '';

  eap-peap.max_message_count = mkIntParam 32 ''
    Maximum number of processed EAP-PEAP packets.
  '';

  eap-peap.include_length = mkYesNoParam no ''
    Include length in non-fragmented EAP-PEAP packets.
  '';

  eap-peap.phase2_method = mkStrParam "mschapv2" ''
    Phase2 EAP client authentication method.
  '';

  eap-peap.phase2_piggyback = mkYesNoParam no ''
    Phase2 EAP Identity request piggybacked by server onto TLS Finished
    message.
  '';

  eap-peap.phase2_tnc = mkYesNoParam no ''
    Start phase2 EAP-TNC protocol after successful client authentication.
  '';

  eap-peap.request_peer_auth = mkYesNoParam no ''
    Request peer authentication based on a client certificate.
  '';

  eap-radius.accounting = mkYesNoParam no ''
    Enable EAP-RADIUS accounting.
  '';

  eap-radius.accounting_close_on_timeout = mkYesNoParam yes ''
    Close the IKE_SA if there is a timeout during interim RADIUS accounting
    updates.
  '';

  eap-radius.accounting_interval = mkIntParam 0 ''
    Interval in seconds for interim RADIUS accounting updates, if not
    specified by the RADIUS server in the Access-Accept message.
  '';

  eap-radius.accounting_requires_vip = mkYesNoParam no ''
    If enabled, accounting is disabled unless an IKE_SA has at least one
    virtual IP.
  '';

  eap-radius.class_group = mkYesNoParam no ''
    Use the class attribute sent in the Access-Accept message as group
    membership information, see EapRadius.
  '';

  eap-radius.close_all_on_timeout = mkYesNoParam no ''
    Closes all IKE_SAs if communication with the RADIUS server times out. If
    it is not set only the current IKE_SA is closed.
  '';

  eap-radius.dae.enable = mkYesNoParam no ''
    Enables support for the Dynamic Authorization Extension (RFC 5176).
  '';

  eap-radius.dae.listen = mkStrParam "0.0.0.0" ''
    Address to listen for DAE messages from the RADIUS server.
  '';

  eap-radius.dae.port = mkIntParam 3799 ''
    Port to listen for DAE requests.
  '';

  eap-radius.dae.secret = mkOptionalStrParam ''
    Shared secret used to verify/sign DAE messages.If set, make sure to
    adjust the permissions of the config file accordingly.
  '';

  eap-radius.eap_start = mkYesNoParam no ''
    Send EAP-Start instead of EAP-Identity to start RADIUS conversation.
  '';

  eap-radius.filter_id = mkYesNoParam no ''
    Use the filter_id attribute sent in the RADIUS-Accept message as group
    membership if the RADIUS tunnel_type attribute is set to ESP.
  '';

  eap-radius.forward.ike_to_radius = mkOptionalStrParam ''
    RADIUS attributes to be forwarded from IKEv2 to RADIUS (can be defined
    by name or attribute number, a colon can be used to specify
    vendor-specific attributes, e.g. Reply-Message, or 11, or 36906:12).
  '';

  eap-radius.forward.radius_to_ike = mkOptionalStrParam ''
    Same as above but from RADIUS to IKEv2, a strongSwan specific private
    notify (40969) is used to transmit the attributes.
  '';

  eap-radius.id_prefix = mkOptionalStrParam ''
    Prefix to EAP-Identity, some AAA servers use a IMSI prefix to select the
    EAP method.
  '';

  eap-radius.nas_identifier = mkStrParam "strongSwan" ''
    NAS-Identifier to include in RADIUS messages.
  '';

  eap-radius.port = mkIntParam 1812 ''
    Port of RADIUS server (authentication).
  '';

  eap-radius.retransmit_base = mkFloatParam "1.4" ''
    Base to use for calculating exponential back off.
  '';

  eap-radius.retransmit_timeout = mkFloatParam "2.0" ''
    Timeout in seconds before sending first retransmit.
  '';

  eap-radius.retransmit_tries = mkIntParam 4 ''
    Number of times to retransmit a packet before giving up.
  '';

  eap-radius.secret = mkOptionalStrParam ''
    Shared secret between RADIUS and NAS. If set, make sure to adjust the
    permissions of the config file accordingly.
  '';

  eap-radius.server = mkOptionalStrParam ''
    IP/Hostname of RADIUS server.
  '';

  eap-radius.servers = mkAttrsOfParams {
    nas_identifier = mkStrParam "strongSwan" ''
      The nas_identifer (default: strongSwan) identifies the gateway against the
      RADIUS server and allows it to enforce a policy, for example.
    '';

    secret = mkOptionalStrParam "";

    sockets = mkIntParam 1 ''
      The number of pre-allocated sockets to use. A value of 5 allows the
      gateway to authentication 5 clients simultaneously over RADIUS.
    '';

    auth_port = mkIntParam 1812 ''
      RADIUS UDP port
    '';

    address = mkOptionalStrParam ''
      The server's IP/Hostname.
    '';

    acct_port = mkIntParam 1813 ''
      Accounting port.
    '';

    preference = mkIntParam 0 ''
      With the preference paramter of a server, priorities for specific servers
      can be defined. This allows to use a secondary RADIUS server only if the
      first gets unresponsive, or if it is overloaded.
    '';
  } ''Section to specify multiple RADIUS servers, see EapRadius.'';

  eap-radius.sockets = mkIntParam 1 ''
    Number of sockets (ports) to use, increase for high load.
  '';

  eap-radius.xauth = mkAttrsOfParams {
    nextpin  = mkOptionalStrParam "";
    password = mkOptionalStrParam "";
    passcode = mkOptionalStrParam "";
    answer   = mkOptionalStrParam "";
  } ''
    Section to configure multiple XAuth authentication rounds via RADIUS.
  '';

  eap-sim.request_identity = mkYesNoParam yes "";

  eap-simaka-sql.database = mkOptionalStrParam "";

  eap-simaka-sql.remove_used = mkOptionalStrParam "";

  eap-tls.fragment_size = mkIntParam  1024 ''
    Maximum size of an EAP-TLS packet.
  '';

  eap-tls.include_length = mkYesNoParam yes ''
    Include length in non-fragmented EAP-TLS packets.
  '';

  eap-tls.max_message_count = mkIntParam 32 ''
    Maximum number of processed EAP-TLS packets (0 = no limit).
  '';

  eap-tnc.max_message_count = mkIntParam 10 ''
    Maximum number of processed EAP-TNC packets (0 = no limit).
  '';

  eap-tnc.protocol = mkStrParam "tnccs-2.0" ''
    IF-TNCCS protocol version to be used (tnccs-1.1, tnccs-2.0,
    tnccs-dynamic).
  '';

  eap-ttls.fragment_size = mkIntParam 1024 ''
    Maximum size of an EAP-TTLS packet.
  '';

  eap-ttls.include_length = mkYesNoParam yes ''
    Include length in non-fragmented EAP-TTLS packets.
  '';

  eap-ttls.max_message_count = mkIntParam 32 ''
    Maximum number of processed EAP-TTLS packets (0 = no limit).
  '';

  eap-ttls.phase2_method = mkStrParam "md5" ''
    Phase2 EAP client authentication method.
  '';

  eap-ttls.phase2_piggyback = mkYesNoParam no ''
    Phase2 EAP Identity request piggybacked by server onto TLS Finished
    message.
  '';

  eap-ttls.phase2_tnc = mkYesNoParam no ''
    Start phase2 EAP TNC protocol after successful client authentication.
  '';

  eap-ttls-phase2_tnc_method = mkEnumParam ["pt" "legacy"] "pt" ''
    Phase2 EAP TNC transport protocol (pt as IETF standard or legacy tnc)
  '';

  eap-ttls.request_peer_auth = mkYesNoParam no ''
    Request peer authentication based on a client certificate.
  '';

  error-notify.socket = mkStrParam "unix://\${piddir}/charon.enfy" ''
    Socket provided by the error-notify plugin.
  '';

  ext-auth.script = mkOptionalStrParam ''
    Shell script to invoke for peer authorization (see ext-auth).
  '';

  gcrypt.quick_random = mkYesNoParam no ''
    Use faster random numbers in gcrypt. For testing only, produces weak
    keys!
  '';

  ha.autobalance = mkIntParam 0 ''
    Interval in seconds to automatically balance handled segments between
    nodes. Set to 0 to disable.
  '';

  ha.fifo_interface = mkYesNoParam yes "";

  ha.heartbeat_delay = mkIntParam 1000 "";

  ha.heartbeat_timeout = mkIntParam 2100 "";

  ha.local = mkOptionalIntParam "";

  ha.monitor = mkYesNoParam yes "";

  ha.pools = mkOptionalStrParam "";

  ha.remote = mkOptionalStrParam "";

  ha.resync = mkYesNoParam yes "";

  ha.secret = mkOptionalStrParam "";

  ha.segment_count = mkIntParam 1 "";

  ipseckey.enable = mkYesNoParam no ''
    Enable fetching of IPSECKEY RRs via DNS.
  '';

  kernel-libipsec.allow_peer_ts = mkYesNoParam no ''
    Allow that the remote traffic selector equals the IKE peer (see
    kernel-libipsec for details).
  '';

  kernel-netlink.buflen = mkOptionalIntParam ''
    Buffer size for received Netlink messages. Defaults to
    <literal>min(PAGE_SIZE, 8192)</literal>.
  '';

  kernel-netlink.force_receive_buffer_size = mkYesNoParam no ''
    If the maximum Netlink socket receive buffer in bytes set by
    receive_buffer_size exceeds the system-wide maximum from
    <literal>/proc/sys/net/core/rmem_max</literal>, this option can be used to
    override the limit. Enabling this option requires special priviliges
    (CAP_NET_ADMIN).
  '';

  kernel-netlink.fwmark = mkOptionalStrParam ''
    Firewall mark to set on the routing rule that directs traffic to our own
    routing table. The format is <literal>[!]mark[/mask]</literal>, where the
    optional exclamation mark inverts the meaning (i.e. the rule only applies to
    packets that don't match the mark). A possible use case are host-to-host
    tunnels with kernel-libipsec. When set to !&#60;mark&#62; a more efficient
    lookup for source and next-hop addresses may also be used since 5.3.3.
  '';

  kernel-netlink.mss = mkIntParam 0 ''
    MSS to set on installed routes, 0 to disable.
  '';

  kernel-netlink.mtu = mkIntParam 0 ''
    MTU to set on installed routes, 0 to disable.
  '';

  kernel-netlink.receive_buffer_size = mkIntParam 0 ''
    Maximum Netlink socket receive buffer in bytes. This value controls how many
    bytes of Netlink messages can be received on a Netlink socket. The default
    value is set by <literal>/proc/sys/net/core/rmem_default</literal>. The
    specified value cannot exceed the system-wide maximum from
    <literal>/proc/sys/net/core/rmem_max</literal>, unless
    <option>force_receive_buffer_size</option> is enabled.
  '';

  kernel-netlink.roam_events = mkYesNoParam yes ''
    Whether to trigger roam events when interfaces, addresses or routes
    change.
  '';

  kernel-netlink.set_proto_port_transport_sa = mkYesNoParam no ''
    Whether to set protocol and ports in the selector installed on transport
    mode IPsec SAs in the kernel. While doing so enforces policies for
    inbound traffic, it also prevents the use of a single IPsec SA by more
    than one traffic selector.
  '';

  kernel-netlink.spdh_thresh.ipv4.lbits = mkIntParam 32 ''
    Local subnet XFRM policy hashing threshold for IPv4.
  '';

  kernel-netlink.spdh_thresh.ipv4.rbits = mkIntParam 32 ''
    Remote subnet XFRM policy hashing threshold for IPv4.
  '';

  kernel-netlink.spdh_thresh.ipv6.lbits = mkIntParam 128 ''
    Local subnet XFRM policy hashing threshold for IPv6.
  '';

  kernel-netlink.spdh_thresh.ipv6.rbits = mkIntParam 128 ''
    Remote subnet XFRM policy hashing threshold for IPv6.
  '';

  kernel-netlink.xfrm_acq_expires = mkIntParam 165 ''
    Lifetime of XFRM acquire state created by the kernel when traffic matches a
    trap policy. The value gets written to
    <literal>/proc/sys/net/core/xfrm_acq_expires</literal>. Indirectly controls
    the delay between XFRM acquire messages triggered by the kernel for a trap
    policy. The same value is used as timeout for SPIs allocated by the
    kernel. The default value equals the default total retransmission timeout
    for IKE messages (since 5.5.3 this value is determined dynamically based on
    the configuration).
  '';

  kernel-pfkey.events_buffer_size = mkIntParam 0 ''
    Size of the receive buffer for the event socket (0 for default
    size). Because events are received asynchronously installing e.g. lots
    of policies may require a larger buffer than the default on certain
    platforms in order to receive all messages.
  '';

  kernel-pfroute.vip_wait = mkIntParam 1000 ''
    Time in ms to wait until virtual IP addresses appear/disappear before
    failing.
  '';

  led.activity_led = mkOptionalStrParam "";

  led.blink_time = mkIntParam 50 "";

  load-tester = {
    addrs = mkAttrsOfParam (mkOptionalStrParam "") ''
      Section that contains key/value pairs with address pools (in CIDR
      notation) to use for a specific network interface e.g.
      <literal>eth0 = 10.10.0.0/16</literal>.
   '';

    addrs_keep = mkYesNoParam no ''
      Whether to keep dynamic addresses even after the associated SA got
      terminated.
    '';

    addrs_prefix = mkIntParam 16 ''
      Network prefix length to use when installing dynamic addresses.
      If set to -1 the full address is used (i.e. 32 or 128).
    '';

    ca_dir = mkOptionalStrParam ''
      Directory to load (intermediate) CA certificates from.
    '';

    child_rekey = mkIntParam 600 ''
      Seconds to start CHILD_SA rekeying after setup.
    '';

    crl = mkOptionalStrParam ''
      URI to a CRL to include as certificate distribution point in generated
      certificates.
    '';

    delay = mkIntParam 0 ''
      Delay between initiatons for each thread.
    '';

    delete_after_established = mkYesNoParam no ''
      Delete an IKE_SA as soon as it has been established.
    '';

    digest = mkStrParam "sha1" ''
      Digest algorithm used when issuing certificates.
    '';

    dpd_delay = mkIntParam 0 ''
      DPD delay to use in load test.
    '';

    dynamic_port = mkIntParam 0 ''
      Base port to be used for requests (each client uses a different port).
    '';

    eap_password = mkStrParam "default-pwd" ''
      EAP secret to use in load test.
    '';

    enable = mkYesNoParam no ''
      Enable the load testing plugin. **WARNING**: Never enable this plugin on
      productive systems. It provides preconfigured credentials and allows an
      attacker to authenticate as any user.
    '';

    esp = mkStrParam "aes128-sha1" ''
      CHILD_SA proposal to use for load tests.
    '';

    fake_kernel = mkYesNoParam no ''
      Fake the kernel interface to allow load-testing against self.
    '';

    ike_rekey = mkIntParam 0 ''
      Seconds to start IKE_SA rekeying after setup.
    '';

    init_limit = mkIntParam 0 ''
      Global limit of concurrently established SAs during load test.
    '';

    initiator = mkStrParam "0.0.0.0" ''
      Address to initiate from.
    '';

    initiators = mkIntParam 0 ''
      Number of concurrent initiator threads to use in load test.
    '';

    initiator_auth = mkStrParam "pubkey" ''
      Authentication method(s) the intiator uses.
    '';

    initiator_id = mkOptionalStrParam ''
      Initiator ID used in load test.
    '';

    initiator_match = mkOptionalStrParam ''
      Initiator ID to match against as responder.
    '';

    initiator_tsi = mkOptionalStrParam ''
      Traffic selector on initiator side, as proposed by initiator.
    '';

    initiator_tsr = mkOptionalStrParam ''
      Traffic selector on responder side, as proposed by initiator.
    '';

    iterations = mkIntParam 1 ''
      Number of IKE_SAs to initiate by each initiator in load test.
    '';

    issuer_cert = mkOptionalStrParam ''
      Path to the issuer certificate (if not configured a hard-coded default
      value is used).
    '';

    issuer_key = mkOptionalStrParam ''
      Path to private key that is used to issue certificates (if not configured
      a hard-coded default value is used).
    '';

    mode = mkEnumParam ["tunnel" "transport" "beet"] "tunnel" ''
      IPsec mode to use.
    '';

    pool = mkOptionalStrParam ''
      Provide INTERNAL_IPV4_ADDRs from a named pool.
    '';

    preshared_key = mkStrParam "<default-psk>" ''
      Preshared key to use in load test.
    '';

    proposal = mkStrParam "aes128-sha1-modp768" ''
      IKE proposal to use in load test.
    '';

    responder = mkStrParam "127.0.0.1" ''
      Address to initiation connections to.
    '';

    responder_auth = mkStrParam "pubkey" ''
      Authentication method(s) the responder uses.
    '';

    responder_id = mkOptionalStrParam ''
      Responder ID used in load test.
    '';

    responder_tsi = mkStrParam "initiator_tsi" ''
      Traffic selector on initiator side, as narrowed by responder.
    '';

    responder_tsr = mkStrParam "initiator_tsr" ''
      Traffic selector on responder side, as narrowed by responder.
    '';

    request_virtual_ip = mkYesNoParam no ''
      Request an INTERNAL_IPV4_ADDR from the server.
    '';

    shutdown_when_complete = mkYesNoParam no ''
      Shutdown the daemon after all IKE_SAs have been established.
    '';

    socket = mkStrParam "unix://\\\${piddir}/charon.ldt" ''
      Socket provided by the load-tester plugin.
    '';

    version = mkIntParam 0 ''
      IKE version to use (0 means use IKEv2 as initiator and accept any version
      as responder).
    '';
  };

  lookip.socket = mkStrParam "unix://\\\${piddir}/charon.lkp" ''
    Socket provided by the lookip plugin.
  '';

  ntru.max_drbg_requests = mkIntParam 4294967294 ''
    Number of pseudo-random bit requests from the DRBG before an automatic
    reseeding occurs.
  '';

  ntru.parameter_set =
    mkEnumParam ["x9_98_speed" "x9_98_bandwidth" "x9_98_balance" "optimum"] "optimum" ''
      The following parameter sets are available:
      <literal>x9_98_speed</literal>, <literal>x9_98_bandwidth</literal>,
      <literal>x9_98_balance</literal> and <literal>optimum</literal>, the last
      set not being part of the X9.98 standard but having the best performance.
    '';

  openssl.engine_id = mkStrParam "pkcs11" ''
    ENGINE ID to use in the OpenSSL plugin.
  '';

  openssl.fips_mode = mkIntParam 0 ''
    Set OpenSSL FIPS mode:
    <itemizedlist>
    <listitem><para>disabled (0),</para></listitem>
    <listitem><para>enabled (1),</para></listitem>
    <listitem><para>Suite B enabled (2).</para></listitem>
    </itemizedlist>
    Defaults to the value configured with the
    <literal>--with-fips-mode</literal> option.

  '';

  osx-attr.append = mkYesNoParam yes ''
    Whether DNS servers are appended to existing entries, instead of
    replacing them.
  '';

  pkcs11.load_certs = mkYesNoParam yes ''
    Whether to load certificates from tokens.
  '';

  pkcs11.modules = mkAttrsOfParams {
    path = mkOptionalStrParam ''
      Full path to the shared object file of this PKCS#11 module
    '';

    os_locking = mkYesNoParam no ''
      Whether OS locking should be enabled for this module
    '';

    load_certs = mkYesNoParam no ''
      Whether the PKCS#11 modules should load certificates from tokens (since 5.0.2)
    '';
  } ''
    List of available PKCS#11 modules, see SmartCardsIKEv2.
  '';

  pkcs11.reload_certs = mkYesNoParam no ''
    Reload certificates from all tokens if charon receives a SIGHUP.
  '';

  pkcs11.use_dh = mkYesNoParam no ''
    Whether the PKCS#11 modules should be used for DH and ECDH.
  '';

  pkcs11.use_ecc = mkYesNoParam no ''
    Whether the PKCS#11 modules should be used for ECDH and ECDSA public key
    operations. ECDSA private keys are used regardless of this option.
  '';

  pkcs11.use_hasher = mkYesNoParam no ''
    Whether the PKCS#11 modules should be used to hash data.
  '';

  pkcs11.use_pubkey = mkYesNoParam no ''
    Whether the PKCS#11 modules should be used for public key operations,
    even for keys not stored on tokens.
  '';

  pkcs11.use_rng = mkYesNoParam no ''
    Whether the PKCS#11 modules should be used as RNG.
  '';

  radattr.dir = mkOptionalStrParam ''
    Directory where RADIUS attributes are stored in client-ID specific
    files, see radattr.
  '';

  radattr.message_id = mkIntParam (-1) ''
    RADIUS attributes are added to all IKE_AUTH messages by default (-1), or
    only to the IKE_AUTH message with the given IKEv2 message ID.
  '';

  random.random = mkStrParam "/dev/random" ''
    File to read random bytes from.
  '';

  random.urandom = mkStrParam "/dev/urandom" ''
    File to read pseudo random bytes from.
  '';

  random.strong_equals_true = mkYesNoParam no ''
    If enabled the RNG_STRONG class reads random bytes from the same source
    as the RNG_TRUE class.
  '';

  resolve.file = mkStrParam "/etc/resolv.conf" ''
    File used by the resolve plugin to write DNS server entries to.
  '';

  resolve.resolvconf.iface_prefix = mkStrParam "lo.inet.ipsec." ''
    Prefix used by the resolve plugin for interface names sent to
    resolvconf(8). The name server address is appended to this prefix to
    make it unique. The result has to be a valid interface name according to
    the rules defined by resolvconf. Also, it should have a high priority
    according to the order defined in interface-order(5).
  '';

  revocation.enable_crl = mkYesNoParam yes ''
    Whether CRL validation should be enabled.
  '';

  revocation.enable_ocsp = mkYesNoParam yes ''
    Whether OCSP validation should be enabled.
  '';

  socket-default.fwmark = mkOptionalStrParam ''
    Firewall mark to set on outbound packets (a possible use case are
    host-to-host tunnels with kernel-libipsec).
  '';

  socket-default.set_source = mkYesNoParam yes ''
    Set source address on outbound packets, if possible.
  '';

  socket-default.set_sourceif = mkYesNoParam no ''
    Force sending interface on outbound packets, if possible. This allows
    using IPv6 link-local addresses as tunnel endpoints.
  '';

  socket-default.use_ipv4 = mkYesNoParam yes ''
    Listen on IPv4, if possible.
  '';

  socket-default.use_ipv6 = mkYesNoParam yes ''
    Listen on IPv6, if possible.
  '';

  sql.database = mkOptionalStrParam ''
    Database URI for charon's SQL plugin. If it contains a password, make
    sure to adjust the permissions of the config file accordingly.
  '';

  sql.loglevel = mkIntParam (-1) ''
    Loglevel for logging to SQL database.
  '';

  stroke.allow_swap = mkYesNoParam yes ''
    Analyze addresses/hostnames in left/right to detect which side is local
    and swap configuration options if necessary. If disabled left is always
    local.
  '';

  stroke.ignore_missing_ca_basic_constraint = mkYesNoParam no ''
    Treat certificates in ipsec.d/cacerts and ipsec.conf ca sections as CA
    certificates even if they don't contain a CA basic constraint.
  '';

  stroke.max_concurrent = mkIntParam 4 ''
    Maximum number of stroke messages handled concurrently.
  '';

  stroke.secrets_file = mkStrParam "\${sysconfdir}/ipsec.secrets" ''
    Location of the ipsec.secrets file.
  '';

  stroke.socket = mkStrParam "unix://\${piddir}/charon.ctl" ''
    Socket provided by the stroke plugin.
  '';

  stroke.timeout = mkIntParam 0 ''
    Timeout in ms for any stroke command. Use 0 to disable the timeout.
  '';

  systime-fix.interval = mkIntParam 0 ''
    Interval in seconds to check system time for validity. 0 disables the
    check. See systime-fix plugin.
  '';

  systime-fix.reauth = mkYesNoParam no ''
    Whether to use reauth or delete if an invalid cert lifetime is detected.
  '';

  systime-fix.threshold = mkOptionalStrParam ''
    Threshold date where system time is considered valid. Disabled if not
    specified.
  '';

  systime-fix.threshold_format = mkStrParam "%Y" ''
    strptime(3) format used to parse threshold option.
  '';

  tnc-ifmap.client_cert = mkOptionalStrParam ''
    Path to X.509 certificate file of IF-MAP client.
  '';

  tnc-ifmap.client_key = mkOptionalStrParam ''
    Path to private key file of IF-MAP client.
  '';

  tnc-ifmap.device_name = mkOptionalStrParam ''
    Unique name of strongSwan server as a PEP and/or PDP device.
  '';

  tnc-ifmap.renew_session_interval = mkIntParam 150 ''
    Interval in seconds between periodic IF-MAP RenewSession requests.
  '';

  tnc-ifmap.server_cert = mkOptionalStrParam ''
    Path to X.509 certificate file of IF-MAP server.
  '';

  tnc-ifmap.server_uri = mkStrParam "https://localhost:8444/imap" ''
    URI of the form <literal>[https://]servername[:port][/path]</literal>.
  '';

  tnc-ifmap.username_password = mkOptionalStrParam ''
    Credentials of IF-MAP client of the form
    <literal>username:password</literal>. If set, make sure to adjust the
    permissions of the config file accordingly.
  '';

  tnc-imc.dlcose = mkYesNoParam yes ''
    Unload IMC after use.
  '';

  tnc-imc.preferred_language = mkStrParam "en" ''
    Preferred language for TNC recommendations.
  '';

  tnc-imv.dlcose = mkYesNoParam yes ''
    Unload IMV after use.
  '';

  tnc-imv.recommendation_policy = mkEnumParam ["default" "any" "all"] "default" ''
    default TNC recommendation policy.
  '';

  tnc-pdp.pt_tls.enable = mkYesNoParam yes ''
    Enable PT-TLS protocol on the strongSwan PDP.
  '';

  tnc-pdp.pt_tls.port = mkIntParam 271 ''
    PT-TLS server port the strongSwan PDP is listening on.
  '';

  tnc-pdp.radius.enable = mkYesNoParam yes ''
    Enable RADIUS protocol on the strongSwan PDP.
  '';

  tnc-pdp.radius.method = mkStrParam "ttls" ''
    EAP tunnel method to be used.
  '';

  tnc-pdp.radius.port = mkIntParam 1812 ''
    RADIUS server port the strongSwan PDP is listening on.
  '';

  tnc-pdp.radius.secret = mkOptionalStrParam ''
    Shared RADIUS secret between strongSwan PDP and NAS. If set, make sure
    to adjust the permissions of the config file accordingly.
  '';

  tnc-pdp.server = mkOptionalStrParam ''
    Name of the strongSwan PDP as contained in the AAA certificate.
  '';

  tnc-pdp.timeout = mkOptionalIntParam ''
    Timeout in seconds before closing incomplete connections.
  '';

  tnccs-11.max_message_size = mkIntParam 45000 ''
    Maximum size of a PA-TNC message (XML &#38; Base64 encoding).
  '';

  tnccs-20.max_batch_size = mkIntParam 65522 ''
    Maximum size of a PB-TNC batch (upper limit via PT-EAP = 65529).
  '';

  tnccs-20.max_message_size = mkIntParam 65490 ''
    Maximum size of a PA-TNC message (upper limit via PT-EAP = 65497).
  '';

  tnccs-20.mutual = mkYesNoParam no ''
    Enable PB-TNC mutual protocol.
  '';

  tpm.use_rng = mkYesNoParam no ''
    Whether the TPM should be used as RNG.
  '';

  unbound.dlv_anchors = mkOptionalStrParam ''
    File to read trusted keys for DLV from. It uses the same format as
    <option>trust_anchors</option>. Only one DLV can be configured, which is
    then used as a root trusted DLV, this means that it is a lookaside for the
    root.
  '';

  unbound.resolv_conf = mkStrParam "/etc/resolv.conf" ''
    File to read DNS resolver configuration from.
  '';

  unbound.trust_anchors = mkStrParam "/etc/ipsec.d/dnssec.keys" ''
    File to read DNSSEC trust anchors from (usually root zone KSK). The
    format of the file is the standard DNS Zone file format, anchors can be
    stored as DS or DNSKEY entries in the file.
  '';

  updown.dns_handler = mkYesNoParam no ''
    Whether the updown script should handle DNS servers assigned via IKEv1
    Mode Config or IKEv2 Config Payloads (if enabled they can't be handled
    by other plugins, like resolve).
  '';

  vici.socket = mkStrParam "unix://\${piddir}/charon.vici" ''
    Socket the vici plugin serves clients.
  '';

  whitelist.enable = mkYesNoParam yes ''
    Enable loaded whitelist plugin.
  '';

  whitelist.socket = mkStrParam "unix://\${piddir}/charon.wlst" ''
    Socket provided by the whitelist plugin.
  '';

  xauth-eap.backend = mkStrParam "radius" ''
    EAP plugin to be used as backend for XAuth credential verification, see
    XAuthEAP.
  '';

  xauth-pam.pam_service = mkStrParam "login" ''
    PAM service to be used for authentication, see XAuthPAM.
  '';

  xauth-pam.session = mkYesNoParam no ''
    Open/close a PAM session for each active IKE_SA.
  '';

  xauth-pam.trim_email = mkYesNoParam yes ''
    If an email address is given as an XAuth username, trim it to just the
    username part.
  '';
}
