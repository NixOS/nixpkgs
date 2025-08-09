{
  lib,
  fetchurl,
}:

lib.extendMkDerivation (
  {
    host,
    path,
    workgroup,

    tls ? false,
    private ? false,
    varPrefix ? null,
    ... # For hash agility
  }@args:
  let
    baseUrl = "${if tls then "smbs" else "smb"}://${host}/${path}";
    passthruAttrs = removeAttrs args [
      "host"
      "path"
      "workgroup"
      "tls"
      "private"
      "varPrefix"
    ];
    varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_SMB_PRIVATE_";
    privateAttrs = lib.optionalAttrs private {
      netrcPhase = ''
        if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
          echo "Error: Private fetchsmb requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
          exit 1
        fi
        cat > netrc <<EOF
        machine ${host}
          login ''$${varBase}USERNAME
          password ''$${varBase}PASSWORD
        EOF
      '';
      netrcImpureEnvVars = [
        "${varBase}USERNAME"
        "${varBase}PASSWORD"
      ];
    };

    fetcherArgs = {
      url = baseUrl;
      curlOpts = "-w ${workgroup}";
    }
    // passthruAttrs
    // privateAttrs;

  in
  fetchurl fetcherArgs
)
