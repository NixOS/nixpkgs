#!/usr/bin/env python3
import time

TOTAL_RETRIES = 20

# BackoffTracker provides a robust system for handling test retries
class BackoffTracker:
    delay = 1
    increment = 1

    def handle_fail(self, retries, message) -> int:
        assert retries < TOTAL_RETRIES, message

        print(f"Retrying in {self.delay}s, {retries + 1}/{TOTAL_RETRIES}")
        time.sleep(self.delay)

        # Only increment after the first try
        if retries == 0:
            self.delay += self.increment
            self.increment *= 2

        return retries + 1

    def protect(self, func):
        def wrapper(*args, retries: int = 0, **kwargs):
            try:
                return func(*args, **kwargs)
            except Exception as err:
                retries = self.handle_fail(retries, err.args)
                return wrapper(*args, retries=retries, **kwargs)

        return wrapper


backoff = BackoffTracker()

def run(node, cmd, fail=False):
    if fail:
        return node.fail(cmd)
    else:
        return node.succeed(cmd)

# Waits for the system to finish booting or switching configuration
def wait_for_running(node):
    node.succeed("systemctl is-system-running --wait")

# On first switch, this will create a symlink to the current system so that we can
# quickly switch between derivations
def switch_to(node, name, fail=False) -> None:
    root_specs = "/tmp/specialisation"
    node.execute(
        f"test -e {root_specs}"
        f" || ln -s $(readlink /run/current-system)/specialisation {root_specs}"
    )

    switcher_path = (
        f"/run/current-system/specialisation/{name}/bin/switch-to-configuration"
    )
    rc, _ = node.execute(f"test -e '{switcher_path}'")
    if rc > 0:
        switcher_path = f"/tmp/specialisation/{name}/bin/switch-to-configuration"

    cmd = f"{switcher_path} test"
    run(node, cmd, fail=fail)
    if not fail:
        wait_for_running(node)

# Ensures the issuer of our cert matches the chain
# and matches the issuer we expect it to be.
# It's a good validation to ensure the cert.pem and fullchain.pem
# are not still selfsigned after verification
@backoff.protect
def check_issuer(node, cert_name, issuer) -> None:
    for fname in ("cert.pem", "fullchain.pem"):
        actual_issuer = node.succeed(
            f"openssl x509 -noout -issuer -in /var/lib/acme/{cert_name}/{fname}"
        ).partition("=")[2]
        assert (
            issuer.lower() in actual_issuer.lower()
        ), f"{fname} issuer mismatch. Expected {issuer} got {actual_issuer}"

# Ensures the provided domain matches with the given cert
def check_domain(node, cert_name, domain, fail=False) -> None:
    cmd = f"openssl x509 -noout -checkhost '{domain}' -in /var/lib/acme/{cert_name}/cert.pem"
    run(node, cmd, fail=fail)

# Ensures the required values for OCSP stapling are present
# Pebble doesn't provide a full OCSP responder, so just checks the URL
def check_stapling(node, cert_name, ca_domain, fail=False):
    rc, _ = node.execute(
        f"openssl x509 -noout -ocsp_uri -in /var/lib/acme/{cert_name}/cert.pem"
        f" | grep -i 'http://{ca_domain}:4002' 2>&1",
    )
    assert rc == 0 or fail, "Failed to find OCSP URI in issued certificate"
    run(
        node,
        f"openssl x509 -noout -ext tlsfeature -in /var/lib/acme/{cert_name}/cert.pem"
        f" | grep -iv 'no extensions' 2>&1",
        fail=fail,
    )

# Checks the keyType by validating the number of bits
def check_key_bits(node, cert_name, bits, fail=False):
    run(
        node,
        f"openssl x509 -noout -text -in /var/lib/acme/{cert_name}/cert.pem"
        f" | grep -i Public-Key | grep {bits} | tee /dev/stderr",
        fail=fail,
    )

# Ensure cert comes before chain in fullchain.pem
def check_fullchain(node, cert_name):
    cert_file = f"/var/lib/acme/{cert_name}/fullchain.pem"
    num_certs = node.succeed(f"grep -o 'END CERTIFICATE' {cert_file}")
    assert len(num_certs.strip().split("\n")) > 1, "Insufficient certs in fullchain.pem"

    first_cert_data = node.succeed(
        f"grep -m1 -B50 'END CERTIFICATE' {cert_file}"
        " | openssl x509 -noout -text"
    )
    for line in first_cert_data.lower().split("\n"):
        if "dns:" in line:
            print(f"First DNSName in fullchain.pem: {line}")
            assert cert_name.lower() in line, f"{cert_name} not found in {line}"
            return

    assert False

# Checks the permissions in the cert directories are as expected
def check_permissions(node, cert_name, group):
    stat = "stat -L -c '%a %U %G' "
    node.succeed(
        f"test $({stat} /var/lib/acme/{cert_name}/*.pem"
        f" | tee /dev/stderr | grep -v '640 acme {group}' | wc -l) -eq 0"
    )
    node.execute(f"ls -lahR /var/lib/acme/.lego/{cert_name}/* > /dev/stderr")
    node.succeed(
        f"test $({stat} /var/lib/acme/.lego/{cert_name}/*/{cert_name}*"
        f" | tee /dev/stderr | grep -v '640 acme {group}' | wc -l) -eq 0"
    )
    node.succeed(
        f"test $({stat} /var/lib/acme/{cert_name}"
        f" | tee /dev/stderr | grep -v '750 acme {group}' | wc -l) -eq 0"
    )
    node.succeed(
        f"test $(find /var/lib/acme/.lego/accounts -type f -exec {stat} {{}} \\;"
        f" | tee /dev/stderr | grep -v '600 acme {group}' | wc -l) -eq 0"
    )


@backoff.protect
def download_ca_certs(node, ca_domain):
    node.succeed(f"curl https://{ca_domain}:15000/roots/0 > /tmp/ca.crt")
    node.succeed(f"curl https://{ca_domain}:15000/intermediate-keys/0 >> /tmp/ca.crt")


@backoff.protect
def check_connection(node, domain, fail=False, minica=False):
    cafile = "/tmp/ca.crt"
    if minica:
        cafile = "/var/lib/acme/.minica/cert.pem"
    run(node,
        f"openssl s_client -brief -CAfile {cafile}"
        f" -verify 2 -verify_return_error -verify_hostname {domain}"
        f" -servername {domain} -connect {domain}:443 < /dev/null",
        fail=fail,
    )
