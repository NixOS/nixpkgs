# Fully pluggable module to have Letsencrypt's Boulder ACME service running in
# a test environment.
#
# The certificate for the ACME service is exported as:
#
#   config.test-support.letsencrypt.caCert
#
# This value can be used inside the configuration of other test nodes to inject
# the snakeoil certificate into security.pki.certificateFiles or into package
# overlays.
#
# Another value that's needed if you don't use a custom resolver (see below for
# notes on that) is to add the letsencrypt node as a nameserver to every node
# that needs to acquire certificates using ACME, because otherwise the API host
# for letsencrypt.org can't be resolved.
#
# A configuration example of a full node setup using this would be this:
#
# {
#   letsencrypt = import ./common/letsencrypt.nix;
#
#   example = { nodes, ... }: {
#     networking.nameservers = [
#       nodes.letsencrypt.config.networking.primaryIPAddress
#     ];
#     security.pki.certificateFiles = [
#       nodes.letsencrypt.config.test-support.letsencrypt.caCert
#     ];
#   };
# }
#
# By default, this module runs a local resolver, generated using resolver.nix
# from the same directory to automatically discover all zones in the network.
#
# If you do not want this and want to use your own resolver, you can just
# override networking.nameservers like this:
#
# {
#   letsencrypt = { nodes, ... }: {
#     imports = [ ./common/letsencrypt.nix ];
#     networking.nameservers = [
#       nodes.myresolver.config.networking.primaryIPAddress
#     ];
#   };
#
#   myresolver = ...;
# }
#
# Keep in mind, that currently only _one_ resolver is supported, if you have
# more than one resolver in networking.nameservers only the first one will be
# used.
#
# Also make sure that whenever you use a resolver from a different test node
# that it has to be started _before_ the ACME service.
{ config, pkgs, lib, ... }:

let
  softhsm = pkgs.stdenv.mkDerivation rec {
    name = "softhsm-${version}";
    version = "1.3.8";

    src = pkgs.fetchurl {
      url = "https://dist.opendnssec.org/source/${name}.tar.gz";
      sha256 = "0flmnpkgp65ym7w3qyg78d3fbmvq3aznmi66rgd420n33shf7aif";
    };

    configureFlags = [ "--with-botan=${pkgs.botan}" ];
    buildInputs = [ pkgs.sqlite ];
  };

  pkcs11-proxy = pkgs.stdenv.mkDerivation {
    name = "pkcs11-proxy";

    src = pkgs.fetchFromGitHub {
      owner = "SUNET";
      repo = "pkcs11-proxy";
      rev = "944684f78bca0c8da6cabe3fa273fed3db44a890";
      sha256 = "1nxgd29y9wmifm11pjcdpd2y293p0dgi0x5ycis55miy97n0f5zy";
    };

    postPatch = "patchShebangs mksyscalls.sh";

    nativeBuildInputs = [ pkgs.cmake ];
    buildInputs = [ pkgs.openssl pkgs.libseccomp ];
  };

  mkGoDep = { goPackagePath, url ? "https://${goPackagePath}", rev, sha256 }: {
    inherit goPackagePath;
    src = pkgs.fetchgit { inherit url rev sha256; };
  };

  goose = let
    owner = "liamstask";
    repo = "goose";
    rev = "8488cc47d90c8a502b1c41a462a6d9cc8ee0a895";
    version = "20150116";

  in pkgs.buildGoPackage rec {
    name = "${repo}-${version}";

    src = pkgs.fetchFromBitbucket {
      name = "${name}-src";
      inherit rev owner repo;
      sha256 = "1jy0pscxjnxjdg3hj111w21g8079rq9ah2ix5ycxxhbbi3f0wdhs";
    };

    goPackagePath = "bitbucket.org/${owner}/${repo}";
    subPackages = [ "cmd/goose" ];
    extraSrcs = map mkGoDep [
      { goPackagePath = "github.com/go-sql-driver/mysql";
        rev = "2e00b5cd70399450106cec6431c2e2ce3cae5034";
        sha256 = "085g48jq9hzmlcxg122n0c4pi41sc1nn2qpx1vrl2jfa8crsppa5";
      }
      { goPackagePath = "github.com/kylelemons/go-gypsy";
        rev = "08cad365cd28a7fba23bb1e57aa43c5e18ad8bb8";
        sha256 = "1djv7nii3hy451n5jlslk0dblqzb1hia1cbqpdwhnps1g8hqjy8q";
      }
      { goPackagePath = "github.com/lib/pq";
        rev = "ba5d4f7a35561e22fbdf7a39aa0070f4d460cfc0";
        sha256 = "1mfbqw9g00bk24bfmf53wri5c2wqmgl0qh4sh1qv2da13a7cwwg3";
      }
      { goPackagePath = "github.com/mattn/go-sqlite3";
        rev = "2acfafad5870400156f6fceb12852c281cbba4d5";
        sha256 = "1rpgil3w4hh1cibidskv1js898hwz83ps06gh0hm3mym7ki8d5h7";
      }
      { goPackagePath = "github.com/ziutek/mymysql";
        rev = "0582bcf675f52c0c2045c027fd135bd726048f45";
        sha256 = "0bkc9x8sgqbzgdimsmsnhb0qrzlzfv33fgajmmjxl4hcb21qz3rf";
      }
      { goPackagePath = "golang.org/x/net";
        url = "https://go.googlesource.com/net";
        rev = "10c134ea0df15f7e34d789338c7a2d76cc7a3ab9";
        sha256 = "14cbr2shl08gyg85n5gj7nbjhrhhgrd52h073qd14j97qcxsakcz";
      }
    ];
  };

  boulder = let
    owner = "letsencrypt";
    repo = "boulder";
    rev = "9866abab8962a591f06db457a4b84c518cc88243";
    version = "20170510";

  in pkgs.buildGoPackage rec {
    name = "${repo}-${version}";

    src = pkgs.fetchFromGitHub {
      name = "${name}-src";
      inherit rev owner repo;
      sha256 = "170m5cjngbrm36wi7wschqw8jzs7kxpcyzmshq3pcrmcpigrhna1";
    };

    postPatch = ''
      # compat for go < 1.8
      sed -i -e 's/time\.Until(\([^)]\+\))/\1.Sub(time.Now())/' \
        test/ocsp/helper/helper.go

      find test -type f -exec sed -i -e '/libpkcs11-proxy.so/ {
        s,/usr/local,${pkcs11-proxy},
      }' {} +

      sed -i -r \
        -e '/^def +install/a \    return True' \
        -e 's,exec \./bin/,,' \
        test/startservers.py

      cat "${snakeOilCa}/ca.key" > test/test-ca.key
      cat "${snakeOilCa}/ca.pem" > test/test-ca.pem
    '';

    goPackagePath = "github.com/${owner}/${repo}";
    buildInputs = [ pkgs.libtool ];
  };

  boulderSource = "${boulder.out}/share/go/src/${boulder.goPackagePath}";

  softHsmConf = pkgs.writeText "softhsm.conf" ''
    0:/var/lib/softhsm/slot0.db
    1:/var/lib/softhsm/slot1.db
  '';

  snakeOilCa = pkgs.runCommand "snakeoil-ca" {
    buildInputs = [ pkgs.openssl ];
  } ''
    mkdir "$out"
    openssl req -newkey rsa:4096 -x509 -sha256 -days 36500 \
      -subj '/CN=Snakeoil CA' -nodes \
      -out "$out/ca.pem" -keyout "$out/ca.key"
  '';

  createAndSignCert = fqdn: let
    snakeoilCertConf = pkgs.writeText "snakeoil.cnf" ''
      [req]
      default_bits = 4096
      prompt = no
      default_md = sha256
      req_extensions = req_ext
      distinguished_name = dn
      [dn]
      CN = ${fqdn}
      [req_ext]
      subjectAltName = DNS:${fqdn}
    '';
  in pkgs.runCommand "snakeoil-certs-${fqdn}" {
    buildInputs = [ pkgs.openssl ];
  } ''
    mkdir "$out"
    openssl genrsa -out "$out/snakeoil.key" 4096
    openssl req -new -key "$out/snakeoil.key" \
      -config ${lib.escapeShellArg snakeoilCertConf} \
      -out snakeoil.csr
    openssl x509 -req -in snakeoil.csr -sha256 -set_serial 666 \
      -CA "${snakeOilCa}/ca.pem" -CAkey "${snakeOilCa}/ca.key" \
      -extfile ${lib.escapeShellArg snakeoilCertConf} \
      -out "$out/snakeoil.pem" -days 36500
  '';

  wfeCerts = createAndSignCert wfeDomain;
  wfeDomain = "acme-v01.api.letsencrypt.org";
  wfeCertFile = "${wfeCerts}/snakeoil.pem";
  wfeKeyFile = "${wfeCerts}/snakeoil.key";

  siteCerts = createAndSignCert siteDomain;
  siteDomain = "letsencrypt.org";
  siteCertFile = "${siteCerts}/snakeoil.pem";
  siteKeyFile = "${siteCerts}/snakeoil.key";

  # Retrieved via:
  # curl -s -I https://acme-v01.api.letsencrypt.org/terms \
  #   | sed -ne 's/^[Ll]ocation: *//p'
  tosUrl = "https://letsencrypt.org/documents/2017.11.15-LE-SA-v1.2.pdf";
  tosPath = builtins.head (builtins.match "https?://[^/]+(.*)" tosUrl);

  tosFile = pkgs.fetchurl {
    url = tosUrl;
    sha256 = "0yvyckqzj0b1xi61sypcha82nanizzlm8yqy828h2jbza7cxi26c";
  };

  resolver = let
    message = "You need to define a resolver for the letsencrypt test module.";
    firstNS = lib.head config.networking.nameservers;
  in if config.networking.nameservers == [] then throw message else firstNS;

  cfgDir = pkgs.stdenv.mkDerivation {
    name = "boulder-config";
    src = "${boulderSource}/test/config";
    nativeBuildInputs = [ pkgs.jq ];
    phases = [ "unpackPhase" "patchPhase" "installPhase" ];
    postPatch = ''
      sed -i -e 's/5002/80/' -e 's/5002/443/' va.json
      sed -i -e '/listenAddress/s/:4000/:80/' wfe.json
      sed -i -r \
        -e ${lib.escapeShellArg "s,http://boulder:4000/terms/v1,${tosUrl},g"} \
        -e 's,http://(boulder|127\.0\.0\.1):4000,https://${wfeDomain},g' \
        -e '/dnsResolver/s/127\.0\.0\.1:8053/${resolver}:53/' \
        *.json
      if grep 4000 *.json; then exit 1; fi

      # Change all ports from 1909X to 909X, because the 1909X range of ports is
      # allocated by startservers.py in order to intercept gRPC communication.
      sed -i -e 's/\<1\(909[0-9]\)\>/\1/' *.json

      # Patch out all additional issuer certs
      jq '. + {ca: (.ca + {Issuers:
        [.ca.Issuers[] | select(.CertFile == "test/test-ca.pem")]
      })}' ca.json > tmp
      mv tmp ca.json
    '';
    installPhase = "cp -r . \"$out\"";
  };

  components = {
    gsb-test-srv.args = "-apikey my-voice-is-my-passport";
    gsb-test-srv.waitForPort = 6000;
    gsb-test-srv.first = true;
    boulder-sa.args = "--config ${cfgDir}/sa.json";
    boulder-wfe.args = "--config ${cfgDir}/wfe.json";
    boulder-ra.args = "--config ${cfgDir}/ra.json";
    boulder-ca.args = "--config ${cfgDir}/ca.json";
    boulder-va.args = "--config ${cfgDir}/va.json";
    boulder-publisher.args = "--config ${cfgDir}/publisher.json";
    boulder-publisher.waitForPort = 9091;
    ocsp-updater.args = "--config ${cfgDir}/ocsp-updater.json";
    ocsp-updater.after = [ "boulder-publisher" ];
    ocsp-responder.args = "--config ${cfgDir}/ocsp-responder.json";
    ct-test-srv = {};
    mail-test-srv.args = "--closeFirst 5";
  };

  commonPath = [ softhsm pkgs.mariadb goose boulder ];

  mkServices = a: b: with lib; listToAttrs (concatLists (mapAttrsToList a b));

  componentServices = mkServices (name: attrs: let
    mkSrvName = n: "boulder-${n}.service";
    firsts = lib.filterAttrs (lib.const (c: c.first or false)) components;
    firstServices = map mkSrvName (lib.attrNames firsts);
    firstServicesNoSelf = lib.remove "boulder-${name}.service" firstServices;
    additionalAfter = firstServicesNoSelf ++ map mkSrvName (attrs.after or []);
    needsPort = attrs ? waitForPort;
    inits = map (n: "boulder-init-${n}.service") [ "mysql" "softhsm" ];
    portWaiter = {
      name = "boulder-${name}";
      value = {
        description = "Wait For Port ${toString attrs.waitForPort} (${name})";
        after = [ "boulder-real-${name}.service" "bind.service" ];
        requires = [ "boulder-real-${name}.service" ];
        requiredBy = [ "boulder.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = let
          netcat = "${pkgs.netcat-openbsd}/bin/nc";
          portCheck = "${netcat} -z 127.0.0.1 ${toString attrs.waitForPort}";
        in "while ! ${portCheck}; do :; done";
      };
    };
  in lib.optional needsPort portWaiter ++ lib.singleton {
    name = if needsPort then "boulder-real-${name}" else "boulder-${name}";
    value = {
      description = "Boulder ACME Component (${name})";
      after = inits ++ additionalAfter;
      requires = inits;
      requiredBy = [ "boulder.service" ];
      path = commonPath;
      environment.GORACE = "halt_on_error=1";
      environment.SOFTHSM_CONF = softHsmConf;
      environment.PKCS11_PROXY_SOCKET = "tcp://127.0.0.1:5657";
      serviceConfig.WorkingDirectory = boulderSource;
      serviceConfig.ExecStart = "${boulder}/bin/${name} ${attrs.args or ""}";
      serviceConfig.Restart = "on-failure";
    };
  }) components;

in {
  imports = [ ./resolver.nix ];

  options.test-support.letsencrypt.caCert = lib.mkOption {
    type = lib.types.path;
    description = ''
      A certificate file to use with the <literal>nodes</literal> attribute to
      inject the snakeoil CA certificate used in the ACME server into
      <option>security.pki.certificateFiles</option>.
    '';
  };

  config = {
    test-support = {
      resolver.enable = let
        isLocalResolver = config.networking.nameservers == [ "127.0.0.1" ];
      in lib.mkOverride 900 isLocalResolver;
      letsencrypt.caCert = "${snakeOilCa}/ca.pem";
    };

    # This has priority 140, because modules/testing/test-instrumentation.nix
    # already overrides this with priority 150.
    networking.nameservers = lib.mkOverride 140 [ "127.0.0.1" ];
    networking.firewall.enable = false;

    networking.extraHosts = ''
      127.0.0.1 ${toString [
        "sa.boulder" "ra.boulder" "wfe.boulder" "ca.boulder" "va.boulder"
        "publisher.boulder" "ocsp-updater.boulder" "admin-revoker.boulder"
        "boulder" "boulder-mysql" wfeDomain
      ]}
      ${config.networking.primaryIPAddress} ${wfeDomain} ${siteDomain}
    '';

    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;

    services.nginx.enable = true;
    services.nginx.recommendedProxySettings = true;
    services.nginx.virtualHosts.${wfeDomain} = {
      onlySSL = true;
      enableACME = false;
      sslCertificate = wfeCertFile;
      sslCertificateKey = wfeKeyFile;
      locations."/".proxyPass = "http://127.0.0.1:80";
    };
    services.nginx.virtualHosts.${siteDomain} = {
      onlySSL = true;
      enableACME = false;
      sslCertificate = siteCertFile;
      sslCertificateKey = siteKeyFile;
      locations.${tosPath}.extraConfig = "alias ${tosFile};";
    };

    systemd.services = {
      pkcs11-daemon = {
        description = "PKCS11 Daemon";
        after = [ "boulder-init-softhsm.service" ];
        before = map (n: "${n}.service") (lib.attrNames componentServices);
        wantedBy = [ "multi-user.target" ];
        environment.SOFTHSM_CONF = softHsmConf;
        environment.PKCS11_DAEMON_SOCKET = "tcp://127.0.0.1:5657";
        serviceConfig.ExecStart = let
          softhsmLib = "${softhsm}/lib/softhsm/libsofthsm.so";
        in "${pkcs11-proxy}/bin/pkcs11-daemon ${softhsmLib}";
      };

      boulder-init-mysql = {
        description = "Boulder ACME Init (MySQL)";
        after = [ "mysql.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.WorkingDirectory = boulderSource;
        path = commonPath;
        script = "${pkgs.bash}/bin/sh test/create_db.sh";
      };

      boulder-init-softhsm = {
        description = "Boulder ACME Init (SoftHSM)";
        environment.SOFTHSM_CONF = softHsmConf;
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.WorkingDirectory = boulderSource;
        preStart = "mkdir -p /var/lib/softhsm";
        path = commonPath;
        script = ''
          softhsm --slot 0 --init-token \
            --label intermediate --pin 5678 --so-pin 1234
          softhsm --slot 0 --import test/test-ca.key \
            --label intermediate_key --pin 5678 --id FB
          softhsm --slot 1 --init-token \
            --label root --pin 5678 --so-pin 1234
          softhsm --slot 1 --import test/test-root.key \
            --label root_key --pin 5678 --id FA
        '';
      };

      boulder = {
        description = "Boulder ACME Server";
        after = map (n: "${n}.service") (lib.attrNames componentServices);
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = let
          ports = lib.range 8000 8005 ++ lib.singleton 80;
          netcat = "${pkgs.netcat-openbsd}/bin/nc";
          mkPortCheck = port: "${netcat} -z 127.0.0.1 ${toString port}";
          checks = "(${lib.concatMapStringsSep " && " mkPortCheck ports})";
        in "while ! ${checks}; do :; done";
      };
    } // componentServices;
  };
}
