# See: https://wiki.strongswan.org/projects/strongswan/wiki/Swanctlconf
#
# When strongSwan is upgraded please update the parameters in this file. You can
# see which parameters should be deleted, changed or added by diffing
# swanctl.opt:
#
#   git clone https://github.com/strongswan/strongswan.git
#   cd strongswan
#   git diff 5.7.2..5.8.0 src/swanctl/swanctl.opt

lib: with (import ./param-constructors.nix lib);

let
  certParams = {
    file = mkOptionalStrParam ''
      Absolute path to the certificate to load. Passed as-is to the daemon, so
      it must be readable by it.

      Configure either this or {option}`handle`, but not both, in one section.
    '';

    handle = mkOptionalHexParam ''
      Hex-encoded CKA_ID or handle of the certificate on a token or TPM,
      respectively.

      Configure either this or {option}`file`, but not both, in one section.
    '';

    slot = mkOptionalIntParam ''
      Optional slot number of the token that stores the certificate.
    '';

    module = mkOptionalStrParam ''
      Optional PKCS#11 module name.
    '';
  };
in {
  authorities = mkAttrsOfParams ({

    cacert = mkOptionalStrParam ''
      The certificates may use a relative path from the swanctl
      `x509ca` directory or an absolute path.

      Configure one of {option}`cacert`,
      {option}`file`, or
      {option}`handle` per section.
    '';

    cert_uri_base = mkOptionalStrParam ''
      Defines the base URI for the Hash and URL feature supported by
      IKEv2. Instead of exchanging complete certificates, IKEv2 allows one to
      send an URI that resolves to the DER encoded certificate. The certificate
      URIs are built by appending the SHA1 hash of the DER encoded certificates
      to this base URI.
    '';

    crl_uris = mkCommaSepListParam [] ''
      List of CRL distribution points (ldap, http, or file URI).
    '';

    ocsp_uris = mkCommaSepListParam [] ''
      List of OCSP URIs.
    '';

  } // certParams) ''
    Section defining complementary attributes of certification authorities, each
    in its own subsection with an arbitrary yet unique name
  '';

  connections = mkAttrsOfParams {

    version = mkIntParam 0 ''
      IKE major version to use for connection.

      - 1 uses IKEv1 aka ISAKMP,
      - 2 uses IKEv2.
      - A connection using the default of 0 accepts both IKEv1 and IKEv2 as
        responder, and initiates the connection actively with IKEv2.
    '';

    local_addrs	= mkCommaSepListParam [] ''
      Local address(es) to use for IKE communication. Takes
      single IPv4/IPv6 addresses, DNS names, CIDR subnets or IP address ranges.

      As initiator, the first non-range/non-subnet is used to initiate the
      connection from. As responder, the local destination address must match at
      least to one of the specified addresses, subnets or ranges.

      If FQDNs are assigned they are resolved every time a configuration lookup
      is done. If DNS resolution times out, the lookup is delayed for that time.
    '';

    remote_addrs = mkCommaSepListParam [] ''
      Remote address(es) to use for IKE communication. Takes
      single IPv4/IPv6 addresses, DNS names, CIDR subnets or IP address ranges.

      As initiator, the first non-range/non-subnet is used to initiate the
      connection to. As responder, the initiator source address must match at
      least to one of the specified addresses, subnets or ranges.

      If FQDNs are assigned they are resolved every time a configuration lookup
      is done. If DNS resolution times out, the lookup is delayed for that time.
      To initiate a connection, at least one specific address or DNS name must
      be specified.
    '';

    local_port = mkIntParam 500 ''
      Local UDP port for IKE communication. By default the port of the socket
      backend is used, which is usually `500`. If port
      `500` is used, automatic IKE port floating to port
      `4500` is used to work around NAT issues.

      Using a non-default local IKE port requires support from the socket
      backend in use (socket-dynamic).
    '';

    remote_port = mkIntParam 500 ''
      Remote UDP port for IKE communication. If the default of port
      `500` is used, automatic IKE port floating to port
      `4500` is used to work around NAT issues.
    '';

    proposals = mkCommaSepListParam ["default"] ''
      A proposal is a set of algorithms. For non-AEAD algorithms, this includes
      for IKE an encryption algorithm, an integrity algorithm, a pseudo random
      function and a Diffie-Hellman group. For AEAD algorithms, instead of
      encryption and integrity algorithms, a combined algorithm is used.

      In IKEv2, multiple algorithms of the same kind can be specified in a
      single proposal, from which one gets selected. In IKEv1, only one
      algorithm per kind is allowed per proposal, more algorithms get implicitly
      stripped. Use multiple proposals to offer different algorithms
      combinations in IKEv1.

      Algorithm keywords get separated using dashes. Multiple proposals may be
      specified in a list. The special value `default` forms a
      default proposal of supported algorithms considered safe, and is usually a
      good choice for interoperability.
    '';

    vips = mkCommaSepListParam [] ''
      List of virtual IPs to request in IKEv2 configuration payloads or IKEv1
      Mode Config. The wildcard addresses `0.0.0.0` and
      `::` request an arbitrary address, specific addresses may
      be defined. The responder may return a different address, though, or none
      at all.
    '';

    aggressive = mkYesNoParam no ''
      Enables Aggressive Mode instead of Main Mode with Identity
      Protection. Aggressive Mode is considered less secure, because the ID and
      HASH payloads are exchanged unprotected. This allows a passive attacker to
      snoop peer identities, and even worse, start dictionary attacks on the
      Preshared Key.
    '';

    pull = mkYesNoParam yes ''
      If the default of yes is used, Mode Config works in pull mode, where the
      initiator actively requests a virtual IP. With no, push mode is used,
      where the responder pushes down a virtual IP to the initiating peer.

      Push mode is currently supported for IKEv1, but not in IKEv2. It is used
      by a few implementations only, pull mode is recommended.
    '';

    dscp = mkStrParam "000000" ''
      Differentiated Services Field Codepoint to set on outgoing IKE packets for
      this connection. The value is a six digit binary encoded string specifying
      the Codepoint to set, as defined in RFC 2474.
    '';

    encap = mkYesNoParam no ''
      To enforce UDP encapsulation of ESP packets, the IKE daemon can fake the
      NAT detection payloads. This makes the peer believe that NAT takes place
      on the path, forcing it to encapsulate ESP packets in UDP.

      Usually this is not required, but it can help to work around connectivity
      issues with too restrictive intermediary firewalls.
    '';

    mobike = mkYesNoParam yes ''
      Enables MOBIKE on IKEv2 connections. MOBIKE is enabled by default on IKEv2
      connections, and allows mobility of clients and multi-homing on servers by
      migrating active IPsec tunnels.

      Usually keeping MOBIKE enabled is unproblematic, as it is not used if the
      peer does not indicate support for it. However, due to the design of
      MOBIKE, IKEv2 always floats to port 4500 starting from the second
      exchange. Some implementations don't like this behavior, hence it can be
      disabled.
    '';

    dpd_delay = mkDurationParam "0s" ''
      Interval to check the liveness of a peer actively using IKEv2
      INFORMATIONAL exchanges or IKEv1 R_U_THERE messages. Active DPD checking
      is only enforced if no IKE or ESP/AH packet has been received for the
      configured DPD delay.
    '';

    dpd_timeout = mkDurationParam "0s" ''
      Charon by default uses the normal retransmission mechanism and timeouts to
      check the liveness of a peer, as all messages are used for liveness
      checking. For compatibility reasons, with IKEv1 a custom interval may be
      specified; this option has no effect on connections using IKEv2.
    '';

    fragmentation = mkEnumParam ["yes" "accept" "force" "no"] "yes" ''
      Use IKE fragmentation (proprietary IKEv1 extension or RFC 7383 IKEv2
      fragmentation). Acceptable values are `yes` (the default
      since 5.5.1), `accept` (since versions:5.5.3),
      `force` and `no`.

      - If set to `yes`, and the peer
        supports it, oversized IKE messages will be sent in fragments.
      - If set to
        `accept`, support for fragmentation is announced to the peer but the daemon
        does not send its own messages in fragments.
      - If set to `force` (only
        supported for IKEv1) the initial IKE message will already be fragmented if
        required.
      - Finally, setting the option to `no` will disable announcing
        support for this feature.

      Note that fragmented IKE messages sent by a peer are always processed
      irrespective of the value of this option (even when set to no).
    '';

    childless = mkEnumParam [ "allow" "force" "never" ] "allow" ''
      Use childless IKE_SA initiation (RFC 6023) for IKEv2.  Acceptable values
      are `allow` (the default), `force` and
      `never`. If set to `allow`, responders
      will accept childless IKE_SAs (as indicated via notify in the IKE_SA_INIT
      response) while initiators continue to create regular IKE_SAs with the
      first CHILD_SA created during IKE_AUTH, unless the IKE_SA is initiated
      explicitly without any children (which will fail if the responder does not
      support or has disabled this extension).  If set to
      `force`, only childless initiation is accepted and the
      first CHILD_SA is created with a separate CREATE_CHILD_SA exchange
      (e.g. to use an independent DH exchange for all CHILD_SAs). Finally,
      setting the option to `never` disables support for
      childless IKE_SAs as responder.
    '';

    send_certreq = mkYesNoParam yes ''
      Send certificate request payloads to offer trusted root CA certificates to
      the peer. Certificate requests help the peer to choose an appropriate
      certificate/private key for authentication and are enabled by default.
      Disabling certificate requests can be useful if too many trusted root CA
      certificates are installed, as each certificate request increases the size
      of the initial IKE packets.
   '';

    send_cert = mkEnumParam ["always" "never" "ifasked" ] "ifasked" ''
      Send certificate payloads when using certificate authentication.

      - With the default of `ifasked` the daemon sends
        certificate payloads only if certificate requests have been received.
      - `never` disables sending of certificate payloads
        altogether,
      - `always` causes certificate payloads to be sent
        unconditionally whenever certificate authentication is used.
    '';

    ppk_id = mkOptionalStrParam ''
       String identifying the Postquantum Preshared Key (PPK) to be used.
    '';

    ppk_required = mkYesNoParam no ''
       Whether a Postquantum Preshared Key (PPK) is required for this connection.
    '';

    keyingtries = mkIntParam 1 ''
      Number of retransmission sequences to perform during initial
      connect. Instead of giving up initiation after the first retransmission
      sequence with the default value of `1`, additional
      sequences may be started according to the configured value. A value of
      `0` initiates a new sequence until the connection
      establishes or fails with a permanent error.
    '';

    unique = mkEnumParam ["no" "never" "keep" "replace"] "no" ''
      Connection uniqueness policy to enforce. To avoid multiple connections
      from the same user, a uniqueness policy can be enforced.

      - The value `never` does never enforce such a policy, even
        if a peer included INITIAL_CONTACT notification messages,
      - whereas `no` replaces existing connections for the same
        identity if a new one has the INITIAL_CONTACT notify.
      - `keep` rejects new connection attempts if the same user
        already has an active connection,
      - `replace` deletes any existing connection if a new one
        for the same user gets established.

      To compare connections for uniqueness, the remote IKE identity is used. If
      EAP or XAuth authentication is involved, the EAP-Identity or XAuth
      username is used to enforce the uniqueness policy instead.

      On initiators this setting specifies whether an INITIAL_CONTACT notify is
      sent during IKE_AUTH if no existing connection is found with the remote
      peer (determined by the identities of the first authentication
      round). Unless set to `never` the client will send a notify.
    '';

    reauth_time	= mkDurationParam "0s" ''
      Time to schedule IKE reauthentication. IKE reauthentication recreates the
      IKE/ISAKMP SA from scratch and re-evaluates the credentials. In asymmetric
      configurations (with EAP or configuration payloads) it might not be
      possible to actively reauthenticate as responder. The IKEv2
      reauthentication lifetime negotiation can instruct the client to perform
      reauthentication.

      Reauthentication is disabled by default. Enabling it usually may lead to
      small connection interruptions, as strongSwan uses a break-before-make
      policy with IKEv2 to avoid any conflicts with associated tunnel resources.
    '';

    rekey_time = mkDurationParam "4h" ''
      IKE rekeying refreshes key material using a Diffie-Hellman exchange, but
      does not re-check associated credentials. It is supported in IKEv2 only,
      IKEv1 performs a reauthentication procedure instead.

      With the default value IKE rekeying is scheduled every 4 hours, minus the
      configured rand_time. If a reauth_time is configured, rekey_time defaults
      to zero, disabling rekeying; explicitly set both to enforce rekeying and
      reauthentication.
    '';

    over_time = mkOptionalDurationParam ''
      Hard IKE_SA lifetime if rekey/reauth does not complete, as time. To avoid
      having an IKE/ISAKMP kept alive if IKE reauthentication or rekeying fails
      perpetually, a maximum hard lifetime may be specified. If the IKE_SA fails
      to rekey or reauthenticate within the specified time, the IKE_SA gets
      closed.

      In contrast to CHILD_SA rekeying, over_time is relative in time to the
      rekey_time and reauth_time values, as it applies to both.

      The default is 10% of the longer of {option}`rekey_time` and
      {option}`reauth_time`.
    '';

    rand_time = mkOptionalDurationParam ''
      Time range from which to choose a random value to subtract from
      rekey/reauth times. To avoid having both peers initiating the rekey/reauth
      procedure simultaneously, a random time gets subtracted from the
      rekey/reauth times.

      The default is equal to the configured {option}`over_time`.
    '';

    pools = mkCommaSepListParam [] ''
      List of named IP pools to allocate virtual IP addresses
      and other configuration attributes from. Each name references a pool by
      name from either the pools section or an external pool.
    '';

    if_id_in = mkStrParam "0" ''
      XFRM interface ID set on inbound policies/SA, can be overridden by child
      config, see there for details.
    '';

    if_id_out = mkStrParam "0" ''
      XFRM interface ID set on outbound policies/SA, can be overridden by child
      config, see there for details.
    '';

    mediation = mkYesNoParam no ''
      Whether this connection is a mediation connection, that is, whether this
      connection is used to mediate other connections using the IKEv2 Mediation
      Extension. Mediation connections create no CHILD_SA.
    '';

    mediated_by = mkOptionalStrParam ''
      The name of the connection to mediate this connection through. If given,
      the connection will be mediated through the named mediation
      connection. The mediation connection must have mediation enabled.
    '';

    mediation_peer = mkOptionalStrParam ''
      Identity under which the peer is registered at the mediation server, that
      is, the IKE identity the other end of this connection uses as its local
      identity on its connection to the mediation server. This is the identity
      we request the mediation server to mediate us with. Only relevant on
      connections that set mediated_by. If it is not given, the remote IKE
      identity of the first authentication round of this connection will be
      used.
    '';

    local = mkPrefixedAttrsOfParams {

      round = mkIntParam 0 ''
        Optional numeric identifier by which authentication rounds are
        sorted. If not specified rounds are ordered by their position in the
        config file/vici message.
      '';

      certs = mkCommaSepListParam [] ''
        List of certificate candidates to use for
        authentication. The certificates may use a relative path from the
        swanctl `x509` directory or an absolute path.

        The certificate used for authentication is selected based on the
        received certificate request payloads. If no appropriate CA can be
        located, the first certificate is used.
      '';

      cert = mkPostfixedAttrsOfParams certParams ''
        Section for a certificate candidate to use for
        authentication. Certificates in certs are transmitted as binary blobs,
        these sections offer more flexibility.
      '';

      pubkeys = mkCommaSepListParam [] ''
        List of raw public key candidates to use for
        authentication. The public keys may use a relative path from the swanctl
        `pubkey` directory or an absolute path.

        Even though multiple local public keys could be defined in principle,
        only the first public key in the list is used for authentication.
      '';

      auth = mkStrParam "pubkey" ''
        Authentication to perform locally.

        - The default `pubkey` uses public key authentication
          using a private key associated to a usable certificate.
        - `psk` uses pre-shared key authentication.
        - The IKEv1 specific `xauth` is used for XAuth or Hybrid
          authentication,
        - while the IKEv2 specific `eap` keyword defines EAP
          authentication.
        - For `xauth`, a specific backend name may be appended,
          separated by a dash. The appropriate `xauth` backend is
          selected to perform the XAuth exchange. For traditional XAuth, the
          `xauth` method is usually defined in the second
          authentication round following an initial `pubkey` (or
          `psk`) round. Using `xauth` in the
          first round performs Hybrid Mode client authentication.
        - For `eap`, a specific EAP method name may be appended, separated by a
          dash. An EAP module implementing the appropriate method is selected to
          perform the EAP conversation.
        - Since 5.4.0, if both peers support RFC 7427 ("Signature Authentication
          in IKEv2") specific hash algorithms to be used during IKEv2
          authentication may be configured. To do so use `ike:`
          followed by a trust chain signature scheme constraint (see description
          of the {option}`remote` section's {option}`auth`
          keyword). For example, with `ike:pubkey-sha384-sha256`
          a public key signature scheme with either SHA-384 or SHA-256 would get
          used for authentication, in that order and depending on the hash
          algorithms supported by the peer. If no specific hash algorithms are
          configured, the default is to prefer an algorithm that matches or
          exceeds the strength of the signature key. If no constraints with
          `ike:` prefix are configured any signature scheme
          constraint (without `ike:` prefix) will also apply to
          IKEv2 authentication, unless this is disabled in
          `strongswan.conf`. To use RSASSA-PSS signatures use
          `rsa/pss` instead of `pubkey` or
          `rsa` as in e.g.
          `ike:rsa/pss-sha256`. If `pubkey` or
          `rsa` constraints are configured RSASSA-PSS signatures
          will only be used if enabled in `strongswan.conf`(5).
      '';

      id = mkOptionalStrParam ''
        IKE identity to use for authentication round. When using certificate
        authentication, the IKE identity must be contained in the certificate,
        either as subject or as subjectAltName.
      '';

      eap_id = mkOptionalStrParam ''
        Client EAP-Identity to use in EAP-Identity exchange and the EAP method.
      '';

      aaa_id = mkOptionalStrParam ''
        Server side EAP-Identity to expect in the EAP method. Some EAP methods,
        such as EAP-TLS, use an identity for the server to perform mutual
        authentication. This identity may differ from the IKE identity,
        especially when EAP authentication is delegated from the IKE responder
        to an AAA backend.

        For EAP-(T)TLS, this defines the identity for which the server must
        provide a certificate in the TLS exchange.
      '';

      xauth_id = mkOptionalStrParam ''
        Client XAuth username used in the XAuth exchange.
      '';

    } ''
      Section for a local authentication round. A local authentication round
      defines the rules how authentication is performed for the local
      peer. Multiple rounds may be defined to use IKEv2 RFC 4739 Multiple
      Authentication or IKEv1 XAuth.

      Each round is defined in a section having `local` as
      prefix, and an optional unique suffix. To define a single authentication
      round, the suffix may be omitted.
    '';

    remote = mkPrefixedAttrsOfParams {

      round = mkIntParam 0 ''
        Optional numeric identifier by which authentication rounds are
        sorted. If not specified rounds are ordered by their position in the
        config file/vici message.
      '';

      id = mkStrParam "%any" ''
        IKE identity to expect for authentication round. When using certificate
        authentication, the IKE identity must be contained in the certificate,
        either as subject or as subjectAltName.
      '';

      eap_id = mkOptionalStrParam ''
        Identity to use as peer identity during EAP authentication. If set to
        `%any` the EAP-Identity method will be used to ask the
        client for an EAP identity.
      '';

      groups = mkCommaSepListParam [] ''
        Authorization group memberships to require. The peer
        must prove membership to at least one of the specified groups. Group
        membership can be certified by different means, for example by
        appropriate Attribute Certificates or by an AAA backend involved in the
        authentication.
      '';

      cert_policy = mkCommaSepListParam [] ''
        List of certificate policy OIDs the peer's certificate
        must have. OIDs are specified using the numerical dotted representation.
      '';

      certs = mkCommaSepListParam [] ''
        List of certificates to accept for authentication. The certificates may
        use a relative path from the swanctl `x509` directory
        or an absolute path.
      '';

      cert = mkPostfixedAttrsOfParams certParams ''
        Section for a certificate candidate to use for
        authentication. Certificates in certs are transmitted as binary blobs,
        these sections offer more flexibility.
      '';

      ca_id = mkOptionalStrParam ''
        Identity in CA certificate to accept for authentication. The specified
        identity must be contained in one (intermediate) CA of the remote peer
        trustchain, either as subject or as subjectAltName. This has the same
        effect as specifying `cacerts` to force clients under
        a CA to specific connections; it does not require the CA certificate
        to be available locally, and can be received from the peer during the
        IKE exchange.
      '';

      cacerts = mkCommaSepListParam [] ''
        List of CA certificates to accept for
        authentication. The certificates may use a relative path from the
        swanctl `x509ca` directory or an absolute path.
      '';

      cacert = mkPostfixedAttrsOfParams certParams ''
        Section for a CA certificate to accept for authentication. Certificates
        in cacerts are transmitted as binary blobs, these sections offer more
        flexibility.
      '';

      pubkeys = mkCommaSepListParam [] ''
        List of raw public keys to accept for
        authentication. The public keys may use a relative path from the swanctl
        `pubkey` directory or an absolute path.
      '';

      revocation = mkEnumParam ["strict" "ifuri" "relaxed"] "relaxed" ''
        Certificate revocation policy for CRL or OCSP revocation.

        - A `strict` revocation policy fails if no revocation information is
          available, i.e. the certificate is not known to be unrevoked.
        - `ifuri` fails only if a CRL/OCSP URI is available, but certificate
          revocation checking fails, i.e. there should be revocation information
          available, but it could not be obtained.
        - The default revocation policy `relaxed` fails only if a certificate is
          revoked, i.e. it is explicitly known that it is bad.
      '';

      auth = mkStrParam "pubkey" ''
        Authentication to expect from remote. See the {option}`local`
        section's {option}`auth` keyword description about the details of
        supported mechanisms.

        Since 5.4.0, to require a trustchain public key strength for the remote
        side, specify the key type followed by the minimum strength in bits (for
        example `ecdsa-384` or
        `rsa-2048-ecdsa-256`). To limit the acceptable set of
        hashing algorithms for trustchain validation, append hash algorithms to
        pubkey or a key strength definition (for example
        `pubkey-sha256-sha512`,
        `rsa-2048-sha256-sha384-sha512` or
        `rsa-2048-sha256-ecdsa-256-sha256-sha384`).
        Unless disabled in `strongswan.conf`, or explicit IKEv2
        signature constraints are configured (refer to the description of the
        {option}`local` section's {option}`auth` keyword for
        details), such key types and hash algorithms are also applied as
        constraints against IKEv2 signature authentication schemes used by the
        remote side. To require RSASSA-PSS signatures use
        `rsa/pss` instead of `pubkey` or
        `rsa` as in e.g. `rsa/pss-sha256`. If
        `pubkey` or `rsa` constraints are
        configured RSASSA-PSS signatures will only be accepted if enabled in
        `strongswan.conf`(5).

        To specify trust chain constraints for EAP-(T)TLS, append a colon to the
        EAP method, followed by the key type/size and hash algorithm as
        discussed above (e.g. `eap-tls:ecdsa-384-sha384`).
      '';

    } ''
      Section for a remote authentication round. A remote authentication round
      defines the constraints how the peers must authenticate to use this
      connection. Multiple rounds may be defined to use IKEv2 RFC 4739 Multiple
      Authentication or IKEv1 XAuth.

      Each round is defined in a section having `remote` as
      prefix, and an optional unique suffix. To define a single authentication
      round, the suffix may be omitted.
    '';

    children = mkAttrsOfParams {
      ah_proposals = mkCommaSepListParam [] ''
        AH proposals to offer for the CHILD_SA. A proposal is a set of
        algorithms. For AH, this includes an integrity algorithm and an optional
        Diffie-Hellman group. If a DH group is specified, CHILD_SA/Quick Mode
        rekeying and initial negotiation uses a separate Diffie-Hellman exchange
        using the specified group (refer to esp_proposals for details).

        In IKEv2, multiple algorithms of the same kind can be specified in a
        single proposal, from which one gets selected. In IKEv1, only one
        algorithm per kind is allowed per proposal, more algorithms get
        implicitly stripped. Use multiple proposals to offer different algorithms
        combinations in IKEv1.

        Algorithm keywords get separated using dashes. Multiple proposals may be
        specified in a list. The special value `default` forms
        a default proposal of supported algorithms considered safe, and is
        usually a good choice for interoperability. By default no AH proposals
        are included, instead ESP is proposed.
     '';

      esp_proposals = mkCommaSepListParam ["default"] ''
        ESP proposals to offer for the CHILD_SA. A proposal is a set of
        algorithms. For ESP non-AEAD proposals, this includes an integrity
        algorithm, an encryption algorithm, an optional Diffie-Hellman group and
        an optional Extended Sequence Number Mode indicator. For AEAD proposals,
        a combined mode algorithm is used instead of the separate
        encryption/integrity algorithms.

        If a DH group is specified, CHILD_SA/Quick Mode rekeying and initial
        negotiation use a separate Diffie-Hellman exchange using the specified
        group. However, for IKEv2, the keys of the CHILD_SA created implicitly
        with the IKE_SA will always be derived from the IKE_SA's key material. So
        any DH group specified here will only apply when the CHILD_SA is later
        rekeyed or is created with a separate CREATE_CHILD_SA exchange. A
        proposal mismatch might, therefore, not immediately be noticed when the
        SA is established, but may later cause rekeying to fail.

        Extended Sequence Number support may be indicated with the
        `esn` and `noesn` values, both may be
        included to indicate support for both modes. If omitted,
        `noesn` is assumed.

        In IKEv2, multiple algorithms of the same kind can be specified in a
        single proposal, from which one gets selected. In IKEv1, only one
        algorithm per kind is allowed per proposal, more algorithms get
        implicitly stripped. Use multiple proposals to offer different algorithms
        combinations in IKEv1.

        Algorithm keywords get separated using dashes. Multiple proposals may be
        specified as a list. The special value `default` forms
        a default proposal of supported algorithms considered safe, and is
        usually a good choice for interoperability. If no algorithms are
        specified for AH nor ESP, the default set of algorithms for ESP is
        included.
      '';

      sha256_96 = mkYesNoParam no ''
        HMAC-SHA-256 is used with 128-bit truncation with IPsec. For
        compatibility with implementations that incorrectly use 96-bit truncation
        this option may be enabled to configure the shorter truncation length in
        the kernel. This is not negotiated, so this only works with peers that
        use the incorrect truncation length (or have this option enabled).
      '';

      local_ts = mkCommaSepListParam ["dynamic"] ''
        List of local traffic selectors to include in CHILD_SA. Each selector is
        a CIDR subnet definition, followed by an optional proto/port
        selector. The special value `dynamic` may be used
        instead of a subnet definition, which gets replaced by the tunnel outer
        address or the virtual IP, if negotiated. This is the default.

        A protocol/port selector is surrounded by opening and closing square
        brackets. Between these brackets, a numeric or getservent(3) protocol
        name may be specified. After the optional protocol restriction, an
        optional port restriction may be specified, separated by a slash. The
        port restriction may be numeric, a getservent(3) service name, or the
        special value `opaque` for RFC 4301 OPAQUE
        selectors. Port ranges may be specified as well, none of the kernel
        backends currently support port ranges, though.

        When IKEv1 is used only the first selector is interpreted, except if the
        Cisco Unity extension plugin is used. This is due to a limitation of the
        IKEv1 protocol, which only allows a single pair of selectors per
        CHILD_SA. So to tunnel traffic matched by several pairs of selectors when
        using IKEv1 several children (CHILD_SAs) have to be defined that cover
        the selectors.  The IKE daemon uses traffic selector narrowing for IKEv1,
        the same way it is standardized and implemented for IKEv2. However, this
        may lead to problems with other implementations. To avoid that, configure
        identical selectors in such scenarios.
      '';

      remote_ts = mkCommaSepListParam ["dynamic"] ''
        List of remote selectors to include in CHILD_SA. See
        {option}`local_ts` for a description of the selector syntax.
      '';

      rekey_time = mkDurationParam "1h" ''
        Time to schedule CHILD_SA rekeying. CHILD_SA rekeying refreshes key
        material, optionally using a Diffie-Hellman exchange if a group is
        specified in the proposal.  To avoid rekey collisions initiated by both
        ends simultaneously, a value in the range of {option}`rand_time`
        gets subtracted to form the effective soft lifetime.

        By default CHILD_SA rekeying is scheduled every hour, minus
        {option}`rand_time`.
      '';

      life_time = mkOptionalDurationParam ''
        Maximum lifetime before CHILD_SA gets closed. Usually this hard lifetime
        is never reached, because the CHILD_SA gets rekeyed before. If that fails
        for whatever reason, this limit closes the CHILD_SA.  The default is 10%
        more than the {option}`rekey_time`.
      '';

      rand_time = mkOptionalDurationParam ''
        Time range from which to choose a random value to subtract from
        {option}`rekey_time`. The default is the difference between
        {option}`life_time` and {option}`rekey_time`.
      '';

      rekey_bytes = mkIntParam 0 ''
        Number of bytes processed before initiating CHILD_SA rekeying. CHILD_SA
        rekeying refreshes key material, optionally using a Diffie-Hellman
        exchange if a group is specified in the proposal.

        To avoid rekey collisions initiated by both ends simultaneously, a value
        in the range of {option}`rand_bytes` gets subtracted to form the
        effective soft volume limit.

        Volume based CHILD_SA rekeying is disabled by default.
      '';

      life_bytes = mkOptionalIntParam ''
        Maximum bytes processed before CHILD_SA gets closed. Usually this hard
        volume limit is never reached, because the CHILD_SA gets rekeyed
        before. If that fails for whatever reason, this limit closes the
        CHILD_SA.  The default is 10% more than {option}`rekey_bytes`.
      '';

      rand_bytes = mkOptionalIntParam ''
        Byte range from which to choose a random value to subtract from
        {option}`rekey_bytes`. The default is the difference between
        {option}`life_bytes` and {option}`rekey_bytes`.
      '';

      rekey_packets = mkIntParam 0 ''
        Number of packets processed before initiating CHILD_SA rekeying. CHILD_SA
        rekeying refreshes key material, optionally using a Diffie-Hellman
        exchange if a group is specified in the proposal.

        To avoid rekey collisions initiated by both ends simultaneously, a value
        in the range of {option}`rand_packets` gets subtracted to form
        the effective soft packet count limit.

        Packet count based CHILD_SA rekeying is disabled by default.
      '';

      life_packets = mkOptionalIntParam ''
        Maximum number of packets processed before CHILD_SA gets closed. Usually
        this hard packets limit is never reached, because the CHILD_SA gets
        rekeyed before. If that fails for whatever reason, this limit closes the
        CHILD_SA.

        The default is 10% more than {option}`rekey_bytes`.
      '';

      rand_packets = mkOptionalIntParam ''
        Packet range from which to choose a random value to subtract from
        {option}`rekey_packets`. The default is the difference between
        {option}`life_packets` and {option}`rekey_packets`.
      '';

      updown = mkOptionalStrParam ''
        Updown script to invoke on CHILD_SA up and down events.
      '';

      hostaccess = mkYesNoParam no ''
        Hostaccess variable to pass to `updown` script.
      '';

      mode = mkEnumParam [ "tunnel"
                           "transport"
                           "transport_proxy"
                           "beet"
                           "pass"
                           "drop"
                         ] "tunnel" ''
        IPsec Mode to establish CHILD_SA with.

        - `tunnel` negotiates the CHILD_SA in IPsec Tunnel Mode,
        - whereas `transport` uses IPsec Transport Mode.
        - `transport_proxy` signifying the special Mobile IPv6
          Transport Proxy Mode.
        - `beet` is the Bound End to End Tunnel mixture mode,
          working with fixed inner addresses without the need to include them in
          each packet.
        - Both `transport` and `beet` modes are
          subject to mode negotiation; `tunnel` mode is
          negotiated if the preferred mode is not available.
        - `pass` and `drop` are used to install
          shunt policies which explicitly bypass the defined traffic from IPsec
          processing or drop it, respectively.
      '';

      policies = mkYesNoParam yes ''
        Whether to install IPsec policies or not. Disabling this can be useful in
        some scenarios e.g. MIPv6, where policies are not managed by the IKE
        daemon. Since 5.3.3.
      '';

      policies_fwd_out = mkYesNoParam no ''
        Whether to install outbound FWD IPsec policies or not. Enabling this is
        required in case there is a drop policy that would match and block
        forwarded traffic for this CHILD_SA. Since 5.5.1.
      '';

      dpd_action = mkEnumParam ["clear" "trap" "restart"] "clear" ''
        Action to perform for this CHILD_SA on DPD timeout. The default clear
        closes the CHILD_SA and does not take further action. trap installs a
        trap policy, which will catch matching traffic and tries to re-negotiate
        the tunnel on-demand. restart immediately tries to re-negotiate the
        CHILD_SA under a fresh IKE_SA.
      '';

      ipcomp = mkYesNoParam no ''
        Enable IPComp compression before encryption. If enabled, IKE tries to
        negotiate IPComp compression to compress ESP payload data prior to
        encryption.
      '';

      inactivity = mkDurationParam "0s" ''
        Timeout before closing CHILD_SA after inactivity. If no traffic has been
        processed in either direction for the configured timeout, the CHILD_SA
        gets closed due to inactivity. The default value of 0 disables inactivity
        checks.
      '';

      reqid = mkIntParam 0 ''
        Fixed reqid to use for this CHILD_SA. This might be helpful in some
        scenarios, but works only if each CHILD_SA configuration is instantiated
        not more than once. The default of 0 uses dynamic reqids, allocated
        incrementally.
      '';

      priority = mkIntParam 0 ''
        Optional fixed priority for IPsec policies. This could be useful to
        install high-priority drop policies. The default of 0 uses dynamically
        calculated priorities based on the size of the traffic selectors.
      '';

      interface = mkOptionalStrParam ''
        Optional interface name to restrict outbound IPsec policies.
      '';

      mark_in = mkStrParam "0/0x00000000" ''
        Netfilter mark and mask for input traffic. On Linux, Netfilter may
        require marks on each packet to match an SA/policy having that option
        set. This allows installing duplicate policies and enables Netfilter
        rules to select specific SAs/policies for incoming traffic. Note that
        inbound marks are only set on policies, by default, unless
        {option}`mark_in_sa` is enabled. The special value
        `%unique` sets a unique mark on each CHILD_SA instance,
        beyond that the value `%unique-dir` assigns a different
        unique mark for each

        An additional mask may be appended to the mark, separated by
        `/`. The default mask if omitted is
        `0xffffffff`.
      '';

      mark_in_sa = mkYesNoParam no ''
        Whether to set {option}`mark_in` on the inbound SA. By default,
        the inbound mark is only set on the inbound policy. The tuple destination
        address, protocol and SPI is unique and the mark is not required to find
        the correct SA, allowing to mark traffic after decryption instead (where
        more specific selectors may be used) to match different policies. Marking
        packets before decryption is still possible, even if no mark is set on
        the SA.
      '';

      mark_out = mkStrParam "0/0x00000000" ''
        Netfilter mark and mask for output traffic. On Linux, Netfilter may
        require marks on each packet to match a policy/SA having that option
        set. This allows installing duplicate policies and enables Netfilter
        rules to select specific policies/SAs for outgoing traffic. The special
        value `%unique` sets a unique mark on each CHILD_SA
        instance, beyond that the value `%unique-dir` assigns a
        different unique mark for each CHILD_SA direction (in/out).

        An additional mask may be appended to the mark, separated by
        `/`. The default mask if omitted is
        `0xffffffff`.
      '';

      set_mark_in = mkStrParam "0/0x00000000" ''
        Netfilter mark applied to packets after the inbound IPsec SA processed
        them. This way it's not necessary to mark packets via Netfilter before
        decryption or right afterwards to match policies or process them
        differently (e.g. via policy routing).

        An additional mask may be appended to the mark, separated by
        `/`. The default mask if omitted is 0xffffffff. The
        special value `%same` uses the value (but not the mask)
        from {option}`mark_in` as mark value, which can be fixed,
        `%unique` or `%unique-dir`.

        Setting marks in XFRM input requires Linux 4.19 or higher.
      '';

      set_mark_out = mkStrParam "0/0x00000000" ''
        Netfilter mark applied to packets after the outbound IPsec SA processed
        them. This allows processing ESP packets differently than the original
        traffic (e.g. via policy routing).

        An additional mask may be appended to the mark, separated by
        `/`. The default mask if omitted is 0xffffffff. The
        special value `%same` uses the value (but not the mask)
        from {option}`mark_out` as mark value, which can be fixed,
        `%unique_` or `%unique-dir`.

        Setting marks in XFRM output is supported since Linux 4.14. Setting a
        mask requires at least Linux 4.19.
      '';

      if_id_in = mkStrParam "0" ''
        XFRM interface ID set on inbound policies/SA. This allows installing
        duplicate policies/SAs and associates them with an interface with the
        same ID. The special value `%unique` sets a unique
        interface ID on each CHILD_SA instance, beyond that the value
        `%unique-dir` assigns a different unique interface ID
        for each CHILD_SA direction (in/out).
      '';

      if_id_out = mkStrParam "0" ''
        XFRM interface ID set on outbound policies/SA. This allows installing
        duplicate policies/SAs and associates them with an interface with the
        same ID. The special value `%unique` sets a unique
        interface ID on each CHILD_SA instance, beyond that the value
        `%unique-dir` assigns a different unique interface ID
        for each CHILD_SA direction (in/out).

        The daemon will not install routes for CHILD_SAs that have this option set.
     '';

      tfc_padding = mkParamOfType (with lib.types; either int (enum ["mtu"])) 0 ''
        Pads ESP packets with additional data to have a consistent ESP packet
        size for improved Traffic Flow Confidentiality. The padding defines the
        minimum size of all ESP packets sent.  The default value of
        `0` disables TFC padding, the special value
        `mtu` adds TFC padding to create a packet size equal to
        the Path Maximum Transfer Unit.
      '';

      replay_window = mkIntParam 32 ''
        IPsec replay window to configure for this CHILD_SA. Larger values than
        the default of `32` are supported using the Netlink
        backend only, a value of `0` disables IPsec replay
        protection.
      '';

      hw_offload = mkEnumParam ["yes" "no" "auto"] "no" ''
        Enable hardware offload for this CHILD_SA, if supported by the IPsec
        implementation. The value `yes` enforces offloading
        and the installation will fail if it's not supported by either kernel or
        device. The value `auto` enables offloading, if it's
        supported, but the installation does not fail otherwise.
      '';

      copy_df = mkYesNoParam yes ''
        Whether to copy the DF bit to the outer IPv4 header in tunnel mode. This
        effectively disables Path MTU discovery (PMTUD). Controlling this
        behavior is not supported by all kernel interfaces.
      '';

      copy_ecn = mkYesNoParam yes ''
        Whether to copy the ECN (Explicit Congestion Notification) header field
        to/from the outer IP header in tunnel mode. Controlling this behavior is
        not supported by all kernel interfaces.
      '';

      copy_dscp = mkEnumParam [ "out" "in" "yes" "no" ] "out" ''
        Whether to copy the DSCP (Differentiated Services Field Codepoint)
        header field to/from the outer IP header in tunnel mode. The value
        `out` only copies the field from the inner to the outer
        header, the value `in` does the opposite and only
        copies the field from the outer to the inner header when decapsulating,
        the value `yes` copies the field in both directions,
        and the value `no` disables copying the field
        altogether. Setting this to `yes` or
        `in` could allow an attacker to adversely affect other
        traffic at the receiver, which is why the default is
        `out`. Controlling this behavior is not supported by
        all kernel interfaces.
      '';

      start_action = mkEnumParam ["none" "trap" "start"] "none" ''
        Action to perform after loading the configuration.

        - The default of `none` loads the connection only, which
          then can be manually initiated or used as a responder configuration.
        - The value `trap` installs a trap policy, which triggers
          the tunnel as soon as matching traffic has been detected.
        - The value `start` initiates the connection actively.

        When unloading or replacing a CHILD_SA configuration having a
        {option}`start_action` different from `none`,
        the inverse action is performed. Configurations with
        `start` get closed, while such with
        `trap` get uninstalled.
      '';

      close_action = mkEnumParam ["none" "trap" "start"] "none" ''
        Action to perform after a CHILD_SA gets closed by the peer.

        - The default of `none` does not take any action,
        - `trap` installs a trap policy for the CHILD_SA.
        - `start` tries to re-create the CHILD_SA.

        {option}`close_action` does not provide any guarantee that the
        CHILD_SA is kept alive. It acts on explicit close messages only, but not
        on negotiation failures. Use trap policies to reliably re-create failed
        CHILD_SAs.
      '';

    } ''
      CHILD_SA configuration sub-section. Each connection definition may have
      one or more sections in its {option}`children` subsection. The
      section name defines the name of the CHILD_SA configuration, which must be
      unique within the connection (denoted \<child\> below).
    '';
  } ''
    Section defining IKE connection configurations, each in its own subsection
    with an arbitrary yet unique name
  '';

  secrets = let
    mkEapXauthParams = mkPrefixedAttrsOfParams {
      secret = mkOptionalStrParam ''
        Value of the EAP/XAuth secret. It may either be an ASCII string, a hex
        encoded string if it has a 0x prefix or a Base64 encoded string if it
        has a 0s prefix in its value.
      '';

      id = mkPrefixedAttrsOfParam (mkOptionalStrParam "") ''
        Identity the EAP/XAuth secret belongs to. Multiple unique identities may
        be specified, each having an `id` prefix, if a secret
        is shared between multiple users.
      '';

    } ''
      EAP secret section for a specific secret. Each EAP secret is defined in a
      unique section having the `eap` prefix. EAP secrets are
      used for XAuth authentication as well.
    '';

  in {

    eap   = mkEapXauthParams;
    xauth = mkEapXauthParams;

    ntlm = mkPrefixedAttrsOfParams {
      secret = mkOptionalStrParam ''
        Value of the NTLM secret, which is the NT Hash of the actual secret,
        that is, MD4(UTF-16LE(secret)). The resulting 16-byte value may either
        be given as a hex encoded string with a 0x prefix or as a Base64 encoded
        string with a 0s prefix.
      '';

      id = mkPrefixedAttrsOfParam (mkOptionalStrParam "") ''
        Identity the NTLM secret belongs to. Multiple unique identities may be
        specified, each having an id prefix, if a secret is shared between
        multiple users.
      '';
    } ''
      NTLM secret section for a specific secret. Each NTLM secret is defined in
      a unique section having the `ntlm` prefix. NTLM secrets
      may only be used for EAP-MSCHAPv2 authentication.
    '';

    ike = mkPrefixedAttrsOfParams {
      secret = mkOptionalStrParam ''
        Value of the IKE preshared secret. It may either be an ASCII string, a
        hex encoded string if it has a 0x prefix or a Base64 encoded string if
        it has a 0s prefix in its value.
      '';

      id = mkPrefixedAttrsOfParam (mkOptionalStrParam "") ''
        IKE identity the IKE preshared secret belongs to. Multiple unique
        identities may be specified, each having an `id`
        prefix, if a secret is shared between multiple peers.
      '';
    } ''
      IKE preshared secret section for a specific secret. Each IKE PSK is
      defined in a unique section having the `ike` prefix.
    '';

    ppk = mkPrefixedAttrsOfParams {
      secret = mkOptionalStrParam ''
        Value of the PPK. It may either be an ASCII string, a hex encoded string
        if it has a `0x` prefix or a Base64 encoded string if
        it has a `0s` prefix in its value. Should have at least
        256 bits of entropy for 128-bit security.
      '';

      id = mkPrefixedAttrsOfParam (mkOptionalStrParam "") ''
        PPK identity the PPK belongs to. Multiple unique identities may be
        specified, each having an `id` prefix, if a secret is
        shared between multiple peers.
      '';
    } ''
      Postquantum Preshared Key (PPK) section for a specific secret. Each PPK is
      defined in a unique section having the `ppk` prefix.
    '';

    private = mkPrefixedAttrsOfParams {
      file = mkOptionalStrParam ''
        File name in the private folder for which this passphrase should be used.
      '';

      secret = mkOptionalStrParam ''
        Value of decryption passphrase for private key.
      '';
    } ''
      Private key decryption passphrase for a key in the
      `private` folder.
    '';

    rsa = mkPrefixedAttrsOfParams {
      file = mkOptionalStrParam ''
        File name in the `rsa` folder for which this passphrase
        should be used.
      '';
      secret = mkOptionalStrParam ''
        Value of decryption passphrase for RSA key.
      '';
    } ''
      Private key decryption passphrase for a key in the `rsa`
      folder.
    '';

    ecdsa = mkPrefixedAttrsOfParams {
      file = mkOptionalStrParam ''
        File name in the `ecdsa` folder for which this
        passphrase should be used.
      '';
      secret = mkOptionalStrParam ''
        Value of decryption passphrase for ECDSA key.
      '';
    } ''
      Private key decryption passphrase for a key in the
      `ecdsa` folder.
    '';

    pkcs8 = mkPrefixedAttrsOfParams {
      file = mkOptionalStrParam ''
        File name in the `pkcs8` folder for which this
        passphrase should be used.
      '';
      secret = mkOptionalStrParam ''
        Value of decryption passphrase for PKCS#8 key.
      '';
    } ''
      Private key decryption passphrase for a key in the
      `pkcs8` folder.
    '';

    pkcs12 = mkPrefixedAttrsOfParams {
      file = mkOptionalStrParam ''
        File name in the `pkcs12` folder for which this
        passphrase should be used.
      '';
      secret = mkOptionalStrParam ''
        Value of decryption passphrase for PKCS#12 container.
      '';
    } ''
      PKCS#12 decryption passphrase for a container in the
      `pkcs12` folder.
    '';

    token = mkPrefixedAttrsOfParams {
      handle = mkOptionalHexParam ''
        Hex-encoded CKA_ID or handle of the private key on the token or TPM,
        respectively.
      '';

      slot = mkOptionalIntParam ''
        Optional slot number to access the token.
      '';

      module = mkOptionalStrParam ''
        Optional PKCS#11 module name to access the token.
      '';

      pin = mkOptionalStrParam ''
        Optional PIN required to access the key on the token. If none is
        provided the user is prompted during an interactive
        `--load-creds` call.
      '';
    } "Definition for a private key that's stored on a token/smartcard/TPM.";

  };

  pools = mkAttrsOfParams {
    addrs = mkOptionalStrParam ''
      Subnet or range defining addresses allocated in pool. Accepts a single
      CIDR subnet defining the pool to allocate addresses from or an address
      range (\<from\>-\<to\>). Pools must be unique and non-overlapping.
    '';

    dns           = mkCommaSepListParam [] "Address or CIDR subnets";
    nbns          = mkCommaSepListParam [] "Address or CIDR subnets";
    dhcp          = mkCommaSepListParam [] "Address or CIDR subnets";
    netmask       = mkCommaSepListParam [] "Address or CIDR subnets";
    server        = mkCommaSepListParam [] "Address or CIDR subnets";
    subnet        = mkCommaSepListParam [] "Address or CIDR subnets";
    split_include = mkCommaSepListParam [] "Address or CIDR subnets";
    split_exclude = mkCommaSepListParam [] "Address or CIDR subnets";
  } ''
    Section defining named pools. Named pools may be referenced by connections
    with the pools option to assign virtual IPs and other configuration
    attributes. Each pool must have a unique name (denoted \<name\> below).
  '';
}
