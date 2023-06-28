import re

actual_lines = machine.succeed("cat /etc/pam.d/login").splitlines()

normal_password_line_number = actual_lines.index(
    "auth sufficient pam_unix.so nullok  likeauth try_first_pass"
)

fingerprint_path = r"^auth sufficient /nix/store/[a-zA-Z0-9]{32}-[a-zA-Z0-9\-/._]+/lib/security/pam_fprintd.so$"
matching_indices = [
    i for i, line in enumerate(actual_lines) if re.match(fingerprint_path, line)
]

with subtest("Fingerprint auth is included"):
    assert len(matching_indices) > 0

with subtest(
    "Fingerprint auth is not included more than once, even when shuffling the order"
):
    assert len(matching_indices) <= 1

with subtest("Password auth is before fingerprint auth"):
    assert normal_password_line_number < matching_indices[0]
