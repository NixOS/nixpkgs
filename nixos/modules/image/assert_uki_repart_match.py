import json
import sys

store_verity_type = "@NIX_STORE_VERITY@"  # replaced at import by Nix


def extract_uki_cmdline_params(ukify_json: dict) -> dict[str, str]:
    """
    Return a dict of the parameters in the .cmdline section of the UKI
    Exits early if "usrhash" is not included.
    """
    cmdline = ukify_json.get(".cmdline", {}).get("text")
    if cmdline is None:
        print("Failed to get cmdline from ukify output")

    params = {}
    for param in cmdline.split():
        key, val = param.partition("=")[::2]
        params[key] = val

    if "usrhash" not in params:
        print(
            f"UKI cmdline does not contain a usrhash:\n{cmdline}"
        )
        exit(1)

    return params


def hashes_match(partition: dict[str, str], expected: str) -> bool:
    """
    Checks if the value of the "roothash" key in the passed partition object matches `expected`.
    """
    if partition.get("roothash") != expected:
        pretty_part = json.dumps(partition, indent=2)
        print(
            f"hash mismatch, expected to find roothash {expected} in:\n{pretty_part}"
        )
        return False
    else:
        return True


def check_partitions(
    partitions: list[dict], uki_params: dict[str, str]
) -> bool:
    """
    Checks if the usrhash from `uki_params` has a matching roothash
    for the corresponding partition in `partitions`.
    """
    for part in partitions:
        if part.get("type") == store_verity_type:
            expected = uki_params["usrhash"]
            return hashes_match(part, expected)

    return False


def main() -> None:
    ukify_json = json.load(sys.stdin)
    repart_json_output = sys.argv[1]

    with open(repart_json_output, "r") as r:
        repart_json = json.load(r)

    uki_params = extract_uki_cmdline_params(ukify_json)

    if check_partitions(repart_json, uki_params):
        print("UKI and repart verity hashes match")
    else:
        print("Compatibility check for UKI and image failed!")
        print(f"UKI cmdline parameters:\n{uki_params}")
        print(f"repart config: {repart_json_output}")
        exit(1)


if __name__ == "__main__":
    main()
