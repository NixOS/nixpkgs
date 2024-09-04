{ stdenv, lib, haskellPackages, writeText, gawk }:
let
  awk                   = "${gawk}/bin/awk";
  dockerCredentialsFile = import ./credentials.nix { inherit lib; };
in
{ fetcher
, name
 , registry    ? "https://registry-1.docker.io/v2/"
 , repository  ? "library"
 , imageName
 , sha256
 , tag         ? ""
 , layerDigest ? ""
}:

# There must be no slashes in the repository or container names since
# we use these to make the output derivation name for the nix store
# path
assert null == lib.findFirst (c: "/"==c) null (lib.stringToCharacters repository);
assert null == lib.findFirst (c: "/"==c) null (lib.stringToCharacters imageName);

# Only allow hocker-config and hocker-layer as fetchers for now
assert (builtins.elem fetcher ["hocker-config" "hocker-layer"]);

# If layerDigest is non-empty then it must not have a 'sha256:' prefix!
assert
  (if layerDigest != ""
   then !lib.hasPrefix "sha256:" layerDigest
   else true);

let
  layerDigestFlag =
    lib.optionalString (layerDigest != "") "--layer ${layerDigest}";
in
stdenv.mkDerivation {
  inherit name;
  builder = writeText "${fetcher}-builder.sh" ''
    source "$stdenv/setup"
    echo "${fetcher} exporting to $out"

    declare -A creds

    # This is a hack for Hydra since we have no way of adding values
    # to the NIX_PATH for Hydra jobsets!!
    staticCredentialsFile="/etc/nix-docker-credentials.txt"
    if [ ! -f "$dockerCredentialsFile" -a -f "$staticCredentialsFile" ]; then
      echo "credentials file not set, falling back on static credentials file at: $staticCredentialsFile"
      dockerCredentialsFile=$staticCredentialsFile
    fi

    if [ -f "$dockerCredentialsFile" ]; then
      echo "using credentials from $dockerCredentialsFile"

      CREDSFILE=$(cat "$dockerCredentialsFile")
      creds[token]=$(${awk} -F'=' '/DOCKER_TOKEN/ {print $2}' <<< "$CREDSFILE" | head -n1)

      # Prefer DOCKER_TOKEN over the username and password
      # authentication method
      if [ -z "''${creds[token]}" ]; then
        creds[user]=$(${awk} -F'=' '/DOCKER_USER/  {print $2}' <<< "$CREDSFILE" | head -n1)
        creds[pass]=$(${awk} -F'=' '/DOCKER_PASS/  {print $2}' <<< "$CREDSFILE" | head -n1)
      fi
    fi

    # These variables will be filled in first by the impureEnvVars, if
    # those variables are empty then they will default to the
    # credentials that may have been read in from the 'DOCKER_CREDENTIALS'
    DOCKER_USER="''${DOCKER_USER:-''${creds[user]}}"
    DOCKER_PASS="''${DOCKER_PASS:-''${creds[pass]}}"
    DOCKER_TOKEN="''${DOCKER_TOKEN:-''${creds[token]}}"

    ${fetcher} --out="$out" \
      ''${registry:+--registry "$registry"} \
      ''${DOCKER_USER:+--username "$DOCKER_USER"} \
      ''${DOCKER_PASS:+--password "$DOCKER_PASS"} \
      ''${DOCKER_TOKEN:+--token "$DOCKER_TOKEN"} \
      ${layerDigestFlag} \
      "${repository}/${imageName}" \
      "${tag}"
  '';

  buildInputs = [ haskellPackages.hocker ];

  outputHashAlgo = "sha256";
  outputHashMode = "flat";
  outputHash = sha256;

  preferLocalBuild = true;

  impureEnvVars = [ "DOCKER_USER" "DOCKER_PASS" "DOCKER_TOKEN" ];

  inherit registry dockerCredentialsFile;
}
