{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stevenblack-blocklist";
  version = "3.15.5";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    tag = finalAttrs.version;
    hash = "sha256-bBQu5n/rMT8bEsBMmv3CtGUZ/ybCTuDw5E2GYZI5woU=";
  };

  outputs = [
    # default src fallback
    "out"

    # base hosts file
    "ads"

    # extensions only
    "fakenews"
    "gambling"
    "porn"
    "social"
  ];

  postPatch = ''
    # Add IPv6 hosts
    process_hosts_file() {
      local input_file="$1"
      local tmpfile=$(mktemp)

      awk '
        /^0\.0\.0\.0/ {
          ipv6 = $0
          gsub("0\\.0\\.0\\.0", "::", ipv6)
          print $0
          print ipv6
          next
        }
        { print $0 }
      ' "$input_file" > "$tmpfile"
      mv "$tmpfile" "$input_file"
    }

    # Process the main hosts file
    process_hosts_file "hosts"

    # Process all alternates hosts files
    for ext in alternates/*; do
      process_hosts_file "$ext/hosts"
    done
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out $ads $fakenews $gambling $porn $social

    # out
    find alternates -type f -not -name "hosts" -exec rm {} +
    cp -r alternates $out
    install -Dm644 hosts $out

    # ads
    install -Dm644 hosts $ads

    # extensions
    install -Dm644 alternates/fakenews-only/hosts $fakenews
    install -Dm644 alternates/gambling-only/hosts $gambling
    install -Dm644 alternates/porn-only/hosts $porn
    install -Dm644 alternates/social-only/hosts $social

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [
      moni
      Guanran928
      frontear
    ];
  };
})
