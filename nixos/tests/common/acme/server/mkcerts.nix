{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, domains ? [ "acme.test" ]
}:

pkgs.runCommand "acme-snakeoil-ca" {
  nativeBuildInputs = [ pkgs.openssl ];
} ''
  addpem() {
    local file="$1"; shift
    local storeFileName="$(IFS=.; echo "$*")"

    echo -n "  " >> "$out"

    # Every following argument is an attribute, so let's recurse and check
    # every attribute whether it must be quoted and write it into $out.
    while [ -n "$1" ]; do
      if expr match "$1" '^[a-zA-Z][a-zA-Z0-9]*$' > /dev/null; then
        echo -n "$1" >> "$out"
      else
        echo -n '"' >> "$out"
        echo -n "$1" | sed -e 's/["$]/\\&/g' >> "$out"
        echo -n '"' >> "$out"
      fi
      shift
      [ -z "$1" ] || echo -n . >> "$out"
    done

    echo " = builtins.toFile \"$storeFileName\" '''" >> "$out"
    sed -e 's/^/    /' "$file" >> "$out"

    echo "  ''';" >> "$out"
  }

  echo '# Generated via mkcert.sh in the same directory.' > "$out"
  echo '{' >> "$out"

  openssl req -newkey rsa:4096 -x509 -sha256 -days 36500 \
    -subj '/CN=Snakeoil CA' -nodes -out ca.pem -keyout ca.key

  addpem ca.key ca key
  addpem ca.pem ca cert

  ${lib.concatMapStrings (fqdn: let
    opensslConfig = pkgs.writeText "snakeoil.cnf" ''
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
  in ''
    export OPENSSL_CONF=${lib.escapeShellArg opensslConfig}
    openssl genrsa -out snakeoil.key 4096
    openssl req -new -key snakeoil.key -out snakeoil.csr
    openssl x509 -req -in snakeoil.csr -sha256 -set_serial 666 \
      -CA ca.pem -CAkey ca.key -out snakeoil.pem -days 36500
    addpem snakeoil.key ${lib.escapeShellArg fqdn} key
    addpem snakeoil.pem ${lib.escapeShellArg fqdn} cert
  '') domains}

  echo '}' >> "$out"
''
