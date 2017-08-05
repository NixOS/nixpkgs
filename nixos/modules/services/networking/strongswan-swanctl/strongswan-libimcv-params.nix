lib : with (import ./param-constructors.nix lib); {
  debug_level = mkIntParam 1 ''
    Debug level for a stand-alone libimcv library.
  '';

  load = mkSpaceSepListParam ["random" "nonce" "gmp" "pubkey" "x509"] ''
    Plugins to load in IMC/IMVs with stand-alone libimcv library.
  '';

  stderr_quiet = mkYesNoParam no ''
    Disable the output to stderr with a stand-alone libimcv library.
  '';

  swid_gen = {
    command = mkStrParam "/usr/local/bin/swid_generator" ''
      SWID generator command to be executed.
    '';

    tag_creator = {
      name = mkStrParam "strongSwan Project" ''
        Name of the tagCreator entity.
      '';

      regid = mkStrParam "strongswan.org" ''
        regid of the tagCreator entity.
      '';
    };
  };

  plugins = {

    imc-attestation = {
      aik_blob = mkOptionalStrParam ''
        AIK encrypted private key blob file.
      '';

      aik_cert = mkOptionalStrParam ''
        AIK certificate file.
      '';

      aik_handle = mkOptionalStrParam ''
        AIK object handle, e.g. 0x81010003.
      '';

      aik_pubkey = mkOptionalStrParam ''
        AIK public key file.
      '';

      mandatory_dh_groups = mkYesNoParam yes ''
        Enforce mandatory Diffie-Hellman groups
      '';

      nonce_len = mkIntParam 20 ''
        DH nonce length.
      '';

      pcr_info = mkYesNoParam no ''
        Whether to send pcr_before and pcr_after info.
      '';

      use_quote2 = mkYesNoParam yes ''
        Use Quote2 AIK signature instead of Quote signature.
      '';

      use_version_info = mkYesNoParam no ''
        Version Info is included in Quote2 signature.
      '';
    };

    imc-hcd.push_info = mkYesNoParam yes ''
      Send quadruple info without being prompted.
    '';

    imc-hcd.subtypes = let
      imcHcdSubtypeParams = let
        softwareParams = mkAttrsOfParams {
          name = mkOptionalStrParam ''
            Name of the software installed on the hardcopy device.
          '';

          patches = mkOptionalStrParam ''
            String describing all patches applied to the given software on this
            hardcopy device. The individual patches are separated by a newline
            character '\\n'.
          '';

          string_version = mkOptionalStrParam ''
            String describing the version of the given software on this hardcopy device.
          '';

          version = mkOptionalStrParam ''
            Hex-encoded version string with a length of 16 octets consisting of
            the fields major version number (4 octets), minor version number (4
            octets), build number (4 octets), service pack major number (2
            octets) and service pack minor number (2 octets).
          '';
        } ''
          Defines a software section having an arbitrary name.
        '';
      in {
        firmware             = softwareParams;
        resident_application = softwareParams;
        user_application     = softwareParams;
        attributes_natural_language = mkStrParam "en" ''
          Variable length natural language tag conforming to RFC 5646 specifies
          the language to be used in the health assessment message of a given
          subtype.
        '';
      };
    in {
      system = imcHcdSubtypeParams // {
        certification_state = mkOptionalStrParam ''
          Hex-encoded certification state.
        '';

        configuration_state = mkOptionalStrParam ''
          Hex-encoded configuration state.
        '';

        machine_type_model = mkOptionalStrParam ''
          String specifying the machine type and model of the hardcopy device.
        '';

        pstn_fax_enabled = mkYesNoParam no ''
          Specifies if a PSTN facsimile interface is installed and enabled on the
          hardcopy device.
        '';

        time_source = mkOptionalStrParam ''
          String specifying the hostname of the network time server used by the
          hardcopy device.
        '';

        user_application_enabled = mkYesNoParam no ''
          Specifies if users can dynamically download and execute applications on
          the hardcopy device.
        '';

        user_application_persistence_enabled = mkYesNoParam no ''
          Specifies if user dynamically downloaded applications can persist outside
          the boundaries of a single job on the hardcopy device.
        '';

        vendor_name = mkOptionalStrParam ''
          String specifying the manufacturer of the hardcopy device.
        '';

        vendor_smi_code = mkOptionalIntParam ''
          Integer specifying the globally unique 24-bit SMI code assigned to the
          manufacturer of the hardcopy device.
        '';
      };
      control   = imcHcdSubtypeParams;
      marker    = imcHcdSubtypeParams;
      finisher  = imcHcdSubtypeParams;
      interface = imcHcdSubtypeParams;
      scanner   = imcHcdSubtypeParams;
    };

    imc-os = {
      device_cert = mkOptionalStrParam ''
        Manually set the path to the client device certificate
        (e.g. /etc/pts/aikCert.der)
      '';

      device_id = mkOptionalStrParam ''
        Manually set the client device ID in hexadecimal format
        (e.g. 1083f03988c9762703b1c1080c2e46f72b99cc31)
      '';

      device_pubkey = mkOptionalStrParam ''
        Manually set the path to the client device public key
        (e.g. /etc/pts/aikPub.der)
      '';

      push_info = mkYesNoParam yes ''
        Send operating system info without being prompted.
      '';
    };

    imc-scanner.push_info = mkYesNoParam yes ''
      Send open listening ports without being prompted.
    '';

    imc-swid = {
      swid_full = mkYesNoParam no ''
        Include file information in the XML-encoded SWID tags.
      '';

      swid_pretty = mkYesNoParam no ''
        Generate XML-encoded SWID tags with pretty indentation.
      '';

      swid_directory = mkStrParam "\${prefix}/share" ''
        Directory where SWID tags are located.
      '';
    };

    imc-swima = {
      eid_epoch = mkHexParam "0x11223344" ''
        Set 32 bit epoch value for event IDs manually if software collector
        database is not available.
      '';

      swid_database = mkOptionalStrParam ''
        URI to software collector database containing event timestamps, software
        creation and deletion events and collected software identifiers.  If it
        contains a password, make sure to adjust the permissions of the config
        file accordingly.
      '';

      swid_directory = mkStrParam "\${prefix}/share" ''
        Directory where SWID tags are located.
      '';

      swid_pretty = mkYesNoParam no ''
        Generate XML-encoded SWID tags with pretty indentation.
      '';

      swid_full = mkYesNoParam no ''
        Include file information in the XML-encoded SWID tags.
      '';
    };

    imc-test = {
      additional_ids = mkIntParam 0 ''
        Number of additional IMC IDs.
      '';

      command = mkStrParam "none" ''
        Command to be sent to the Test IMV.
      '';

      dummy_size = mkIntParam 0 ''
        Size of dummy attribute to be sent to the Test IMV (0 = disabled).
      '';

      retry = mkYesNoParam no ''
        Do a handshake retry.
      '';

      retry_command = mkOptionalStrParam ''
        Command to be sent to the IMV Test in the handshake retry.
      '';
    };

    imv-attestation = {
      cadir = mkOptionalStrParam ''
        Path to directory with AIK cacerts.
      '';

      dh_group = mkStrParam "ecp256" ''
        Preferred Diffie-Hellman group.
      '';

      hash_algorithm = mkStrParam "sha256" ''
        Preferred measurement hash algorithm.
      '';

      min_nonce_len = mkIntParam 0 ''
        DH minimum nonce length.
      '';

      remediation_uri = mkOptionalStrParam ''
        URI pointing to attestation remediation instructions.
      '';
    };

    imv-os.remediation_uri = mkOptionalStrParam ''
      URI pointing to operating system remediation instructions.
    '';

    imv-scanner.remediation_uri = mkOptionalStrParam ''
      URI pointing to scanner remediation instructions.
    '';

    imv-swima.rest_api = {
      uri = mkOptionalStrParam ''
        HTTP URI of the SWID REST API.
      '';

      timeout = mkIntParam 120 ''
        Timeout of SWID REST API HTTP POST transaction.
      '';
    };

    imv-test.rounds = mkIntParam 0 ''
      Number of IMC-IMV retry rounds.
    '';
  };
}
