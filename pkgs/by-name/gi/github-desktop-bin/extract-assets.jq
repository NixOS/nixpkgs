.assets
    | map(select(.label | contains("macOS x64")))[0] as $x64
    | map(select(.label | contains("macOS arm64")))[0] as $arm64
| { x64: $x64, arm64: $arm64 }
| map_values({ url: .browser_download_url, hash: .digest })
