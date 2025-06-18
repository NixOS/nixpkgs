{
  stevenblack-blocklist,
}:

stevenblack-blocklist.overrideAttrs (oldAttrs: {
  pname = "${oldAttrs.pname}-ipv6";

  postPatch = ''
    # Add IPv6 hosts
    process_hosts_file() {
      local input_file="$1"
      local tmpfile=$(mktemp)

      awk '
        /^#? ?0\.0\.0\.0/ {
          ipv6 = $0
          sub("0\\.0\\.0\\.0", "::", ipv6)
          print $0
          print ipv6
          next
        }
        { print $0 }
      ' "$input_file" > "$tmpfile"
      mv "$tmpfile" "$input_file"
    }
    process_hosts_file "hosts"
    for ext in alternates/*; do
      process_hosts_file "$ext/hosts"
    done
  '';

  meta.description = "${oldAttrs.meta.description} with IPv6 support";
})
