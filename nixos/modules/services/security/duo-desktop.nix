{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.duo-desktop;
  installDir = "${cfg.package}/opt/duo/duo-desktop";
  keysDir = "/etc/opt/duo/duo-desktop/https";
  certPath = "${keysDir}/duo-desktop.crt";
  keyPath = "${keysDir}/duo-desktop.key";
  pfxPath = "${keysDir}/duo-desktop.pfx";

  # Certificate generation script
  # Regenerate if the cert is missing or expires within 30 days (2592000 seconds)
  certGenerationScript = ''
    if [ ! -f "${certPath}" ] || ! openssl x509 -checkend 2592000 -noout -in "${certPath}" 2>/dev/null; then
      mkdir -p "${keysDir}"
      chmod 700 "${keysDir}"
      openssl req \
        -newkey rsa:2048 -keyout "${keyPath}" \
        -x509 \
        -days 1095 \
        -nodes \
        -config "${installDir}/localhost.cfg" \
        -out "${certPath}" 2>/dev/null
      openssl pkcs12 \
        -inkey "${keyPath}" -in "${certPath}" \
        -export -out "${pfxPath}" \
        -passout pass:
      rm -f "${keyPath}"
      chmod 600 "${pfxPath}"
      chmod 644 "${certPath}"
    fi
  '';
in
{
  options.services.duo-desktop = {
    enable = lib.mkEnableOption "Duo Desktop";
    package = lib.mkPackageOption pkgs "duo-desktop" { };
  };

  config = lib.mkIf cfg.enable {

    # Include the systemd units from the package
    systemd.packages = [ cfg.package ];

    # Generate certificate during system activation to ensure it exists for the trust bundle
    system.activationScripts.duo-desktop-cert-generate = {
      deps = [ "specialfs" ];
      text = ''
        ${certGenerationScript}
      '';
    };

    # Add the generated cert to the NixOS system trust bundle.
    security.pki.certificateFiles = [ certPath ];

    # Enable the duo-desktop daemon
    systemd.services.duo-desktop = {
      serviceConfig = {
        # Override the ExecStart to point to the wrapper
        ExecStart = [
          ""
          "${cfg.package}/bin/duo-desktop"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
