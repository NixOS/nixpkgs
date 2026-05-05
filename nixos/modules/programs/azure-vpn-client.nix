{
  # keep-sorted start
  config,
  lib,
  pkgs,
  # keep-sorted end
  ...
}:
let
  cfg = config.programs.azure-vpn-client;
  desktopItem = pkgs.makeDesktopItem {
    name = "Azure VPN Client";
    desktopName = "Azure VPN Client";
    comment = "Azure VPN client";
    exec = "azure-vpn-client";
    tryExec = "azure-vpn-client";
    icon = "${cfg.package}/share/icons/microsoft-azurevpnclient.png";
    terminal = false;
    categories = [ "Utility" ];
    startupWMClass = "AzureVpnClient";
  };
in
{
  options.programs.azure-vpn-client = {
    enable = lib.mkEnableOption "Microsoft Azure VPN Client";

    package = lib.mkPackageOption pkgs "azure-vpn-client-unwrapped" { };

    certificates = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = pkgs.azure-vpn-client-unwrapped.certificates;
      defaultText = lib.literalExpression "pkgs.azure-vpn-client-unwrapped.certificates";
      example = lib.literalExpression ''
        {
          "corp-root-ca.pem" = pkgs.azure-vpn-client-unwrapped.toPem ./certs/corp-root-ca.crt;
          "DigiCert_Global_Root_CA.pem" =
            pkgs.azure-vpn-client-unwrapped.toPem "''${cacert.unbundled}/etc/ssl/certs/DigiCert_Global_Root_CA:83be056904246b1a1756ac95991c74a.crt";
        }
      '';
      description = ''
        Certificates to install.

        The certificates need to be processed with openssl x509 into the PEM
        format. Otherwise they will be rejected by the VPN.

        See the example for more information and a helper to convert them.
      '';
    };
  };

  config =
    let
      makeCertificatesDir =
        attrs:
        lib.mapAttrs' (name: source: lib.nameValuePair "ssl/certs/${name}" { inherit source; }) attrs;
    in
    lib.mkIf cfg.enable {
      # The VPN is hardcoded to enumerate the `/etc/ssl/certs` directory and list
      # every file as individual certificate.
      environment.etc = makeCertificatesDir cfg.certificates;

      environment.systemPackages = [ desktopItem ];

      services.resolved.enable = lib.mkDefault true;

      boot.kernelModules = lib.mkDefault [ "tun" ];

      security.polkit.enable = lib.mkDefault true;

      security.wrappers.azure-vpn-client = {
        source = "${cfg.package}/bin/microsoft-azurevpnclient";
        capabilities = "cap_net_admin+ep";
        owner = "root";
        group = "root";
      };
    };

  meta.maintainers = with lib.maintainers; [ elias-graf ];
}
