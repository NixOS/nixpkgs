def parse(args):
    map(args.data.versions[0][args.key] as $info
        | select($info.url != null)
        | {(.name): {
            pname: .name,
            name: $info.url
                | split("/")[8],
            version: $info.url
                | split("/")[7]
                | sub("^esp-"; "")
                | sub("^gdb-"; "")
                | sub("^develop-"; "")
                | sub("^v"; "")
                | sub("^esp32ulp-elf-"; ""),
            url: $info.url,
            sha256: $info.sha256,
        }}
        )
    | add;

.tools
    | {
        "any": parse({"data": ., "key": "any"}),
        "aarch64-darwin": parse({"data": ., "key": "macos-arm64"}),
        "aarch64-linux": parse({"data": ., "key": "linux-arm64"}),
        "x86_64-darwin": parse({"data": ., "key": "macos"}),
        "x86_64-linux": parse({"data": ., "key": "linux-amd64"}),
    }
