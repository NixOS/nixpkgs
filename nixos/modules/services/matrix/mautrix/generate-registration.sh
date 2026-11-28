config_template="$1"
registration_file="$2"
executable="$3"
schema="$4"
secret_prefix="$5"
rate_limited="$6"

umask 0077
mautrix-substitute-config "$config_template" config.yaml.tmp
mv config.yaml.tmp config.yaml

# Keep the common secret interface independent of the upstream schema.
# shellcheck disable=SC2016
yq -Y \
  --arg schema "$schema" \
  --arg prefix "$secret_prefix" '
  (env["MAUTRIX_" + $prefix + "_BRIDGE_LOGIN_SHARED_SECRET"] // env.MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET) as $secret
  | if ($secret // "") == "" then .
    elif $schema == "bridgev2" then .double_puppet.secrets[.homeserver.domain] = $secret
    else .bridge.login_shared_secret_map[.homeserver.domain] = $secret end
' config.yaml > config.yaml.tmp
mv config.yaml.tmp config.yaml

# Explicit tokens take precedence; otherwise retain the existing registration.
if [ -f "$registration_file" ]; then
  cp "$registration_file" registration.yaml.old
  # shellcheck disable=SC2016
  yq -sY '
    def configured: . != null and . != "" and . != "generate"
      and . != "This value is generated when generating the registration";
    .[1] as $registration | .[0]
    | if (.appservice.as_token | configured) then . else .appservice.as_token = $registration.as_token end
    | if (.appservice.hs_token | configured) then . else .appservice.hs_token = $registration.hs_token end
  ' config.yaml registration.yaml.old > config.yaml.tmp
  mv config.yaml.tmp config.yaml
else
  echo "{}" > registration.yaml.old
fi

# Registration generation may rewrite the input and rotate its tokens.
cp config.yaml config-registration.yaml
"$executable" --generate-registration \
  --config=config-registration.yaml --registration=registration.yaml.new
# shellcheck disable=SC2016
yq -sY \
  --argjson rate_limited "$rate_limited" '
  def configured: . != null and . != "" and . != "generate"
    and . != "This value is generated when generating the registration";
  .[0] as $config | .[1] as $new_reg | .[2] as $old_reg | $new_reg
  | if ($config.appservice.as_token | configured) then .as_token = $config.appservice.as_token else . end
  | if ($config.appservice.hs_token | configured) then .hs_token = $config.appservice.hs_token else . end
  | if ($old_reg | type == "object" and has("sender_localpart")) then .sender_localpart = $old_reg.sender_localpart else . end
  | .rate_limited = $rate_limited
' config.yaml registration.yaml.new registration.yaml.old > registration.yaml.tmp
chmod 640 registration.yaml.tmp
mv registration.yaml.tmp "$registration_file"
yq -sY '
  .[0].appservice.as_token = .[1].as_token
  | .[0].appservice.hs_token = .[1].hs_token | .[0]
' config.yaml "$registration_file" > config.yaml.tmp
mv config.yaml.tmp config.yaml
rm config-registration.yaml registration.yaml.new registration.yaml.old
