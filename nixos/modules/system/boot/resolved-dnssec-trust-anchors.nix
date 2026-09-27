{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    concatLines
    mapAttrs'
    mapAttrsToList
    mkIf
    mkOption
    nameValuePair
    types
    ;

  cfg = config.services.resolved.dnssecTrustAnchors;

  hex = types.strMatching "([0-9A-Fa-f]{2})+";
  base64 = types.strMatching "[A-Za-z0-9+/=]+";

  commonRecordOptions = {
    domain = mkOption {
      type = types.str;
      example = ".";
      description = ''
        Domain name for the record. Use "." for the DNS root.
      '';
    };
  };

  dsRecordType = types.submodule {
    options = commonRecordOptions // {
      keyTag = mkOption {
        type = types.ints.u16;
        example = 20326;
        description = "DNSSEC DS key tag.";
      };

      algorithm = mkOption {
        type = types.ints.u8;
        example = 8;
        description = "DNSSEC signing algorithm number.";
      };

      digestType = mkOption {
        type = types.ints.u8;
        example = 2;
        description = "DNSSEC DS digest algorithm number.";
      };

      digest = mkOption {
        type = hex;
        example = "e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d";
        description = "Hex-encoded DS digest.";
      };
    };
  };

  dnskeyRecordType = types.submodule {
    options = commonRecordOptions // {
      flags = mkOption {
        type = types.ints.u16;
        example = 257;
        description = "DNSKEY flags field.";
      };

      protocol = mkOption {
        type = types.ints.u8;
        default = 3;
        example = 3;
        description = "DNSKEY protocol field.";
      };

      algorithm = mkOption {
        type = types.ints.u8;
        example = 8;
        description = "DNSSEC signing algorithm number.";
      };

      publicKey = mkOption {
        type = base64;
        example = "AwEAAagAIKlVZrpC6Ia7gEzahOR+9W29euxhJhVVLOyQbSEW0O8gcCjFFVQUTf6v58fLjwBd0YI0EzrAcQqBGCzh/RStIoO8g0NfnfL2MTJRkxoXbfDaUeVPQuYEhg37NZWAJQ9VnMVDxP/VHL496M/QZxkjf5/Efucp2gaDX6RS6CXpoY68LsvPVjR0ZSwzz1apAzvN9dlzEheX7ICJBBtuA6G3LQpzW5hOA2hzCTMjJPJ8LbqF6dsV6DoBQzgul0sGIcGOYl7OyQdXfZ57relSQageu+ipAdTTJ25AsRTAoub8ONGcLmqrAmRLKBP1dfwhYB4N7knNnulqQxA+Uk1ihz0=";
        description = "DNSKEY public key.";
      };
    };
  };

  structuredRecordType = types.attrTag {
    DS = mkOption {
      type = dsRecordType;
      description = "DS trust anchor record.";
    };

    DNSKEY = mkOption {
      type = dnskeyRecordType;
      description = "DNSKEY trust anchor record.";
    };
  };

  renderRecord =
    record:
    if builtins.isString record then
      record
    else if record ? DS then
      let
        r = record.DS;
      in
      "${r.domain} IN DS ${toString r.keyTag} ${toString r.algorithm} ${toString r.digestType} ${r.digest}"
    else
      let
        r = record.DNSKEY;
      in
      "${r.domain} IN DNSKEY ${toString r.flags} ${toString r.protocol} ${toString r.algorithm} ${r.publicKey}";

  positiveAnchorFileType = types.submodule {
    options.content = mkOption {
      type = with types; listOf (either str structuredRecordType);
      default = [ ];
      apply = value: concatLines (map renderRecord value);
      example = lib.literalExpression ''
        # Usually not needed for "." because systemd-resolved has a built-in root trust anchor.
        # Prefer DS records over DNSKEY records unless you know why you need DNSKEY.
        [
          ". IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d"
          ". IN DNSKEY 257 3 8 AwEAAagAIKlVZrpC6Ia7gEzahOR+9W29euxhJhVVLOyQbSEW0O8gcCjFFVQUTf6v58fLjwBd0YI0EzrAcQqBGCzh/RStIoO8g0NfnfL2MTJRkxoXbfDaUeVPQuYEhg37NZWAJQ9VnMVDxP/VHL496M/QZxkjf5/Efucp2gaDX6RS6CXpoY68LsvPVjR0ZSwzz1apAzvN9dlzEheX7ICJBBtuA6G3LQpzW5hOA2hzCTMjJPJ8LbqF6dsV6DoBQzgul0sGIcGOYl7OyQdXfZ57relSQageu+ipAdTTJ25AsRTAoub8ONGcLmqrAmRLKBP1dfwhYB4N7knNnulqQxA+Uk1ihz0="
          {
            DS = {
              domain = ".";
              keyTag = 20326;
              algorithm = 8;
              digestType = 2;
              digest = "e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d";
            };
          }

          {
            DNSKEY = {
              domain = ".";
              flags = 257;
              protocol = 3;
              algorithm = 8;
              publicKey = "AwEAAagAIKlVZrpC6Ia7gEzahOR+9W29euxhJhVVLOyQbSEW0O8gcCjFFVQUTf6v58fLjwBd0YI0EzrAcQqBGCzh/RStIoO8g0NfnfL2MTJRkxoXbfDaUeVPQuYEhg37NZWAJQ9VnMVDxP/VHL496M/QZxkjf5/Efucp2gaDX6RS6CXpoY68LsvPVjR0ZSwzz1apAzvN9dlzEheX7ICJBBtuA6G3LQpzW5hOA2hzCTMjJPJ8LbqF6dsV6DoBQzgul0sGIcGOYl7OyQdXfZ57relSQageu+ipAdTTJ25AsRTAoub8ONGcLmqrAmRLKBP1dfwhYB4N7knNnulqQxA+Uk1ihz0=";
            };
          }
        ]
      '';
      description = ''
        A list of raw/structured DS and DNSKEY records to place in the .positive file.
      '';
    };
  };

  negativeAnchorFileType = types.submodule {
    options.content = mkOption {
      type = with types; listOf str;
      default = [ ];
      apply = value: concatLines value;
      example = [
        "prod"
        "stag"
        "corp.internal"
        "10.in-addr.arpa"
      ];
      description = ''
        A list of domain names for which DNSSEC validation should be disabled.
      '';
    };
  };

  mkEtcTrustAnchorFile =
    kind: name: file:
    nameValuePair "dnssec-trust-anchors.d/${name}.${kind}" { text = file.content; };
  positiveEtcFiles = mapAttrs' (mkEtcTrustAnchorFile "positive") cfg.positive;
  negativeEtcFiles = mapAttrs' (mkEtcTrustAnchorFile "negative") cfg.negative;
  trustAnchorFiles = positiveEtcFiles // negativeEtcFiles;
in
{
  options.services.resolved.dnssecTrustAnchors = {
    positive = mkOption {
      type = types.attrsOf positiveAnchorFileType;
      default = { };
      description = ''
        Positive DNSSEC trust anchor files for systemd-resolved.
        See {manpage}`dnssec-trust-anchors.d(5)` for details.

        These files are only used by systemd-resolved when DNSSEC validation is
        enabled, for example when {option}`services.resolved.settings.Resolve.DNSSEC`
        is set to `true` or `"allow-downgrade"`. Also set
        {option}`services.resolved.enable` = true.

        Attribute names are file basenames. The module appends ".positive"
        automatically and writes files to /etc/dnssec-trust-anchors.d/.
      '';
    };

    negative = mkOption {
      type = types.attrsOf negativeAnchorFileType;
      default = { };
      description = ''
        Negative DNSSEC trust anchor files for systemd-resolved.
        See {manpage}`dnssec-trust-anchors.d(5)` for details.

        These files are only used by systemd-resolved when DNSSEC validation is
        enabled, for example when {option}`services.resolved.settings.Resolve.DNSSEC`
        is set to `true` or `"allow-downgrade"`. Also set
        {option}`services.resolved.enable` = true.

        Note that configuring any negative trust anchor files may affect systemd-resolved's
        built-in negative trust anchors for private DNS zones. Check {manpage}`dnssec-trust-anchors.d(5)`
        before replacing the default behaviour.

        Attribute names are file basenames. The module appends ".negative"
        automatically and writes files to /etc/dnssec-trust-anchors.d/.
      '';
    };
  };

  config = mkIf (cfg.positive != { } || cfg.negative != { }) {
    environment.etc = trustAnchorFiles;
    systemd.services.systemd-resolved.reloadTriggers = mkIf config.services.resolved.enable (
      mapAttrsToList (name: _: config.environment.etc.${name}.source) trustAnchorFiles
    );
  };
}
