nix-update

importTree="(let tree = import ./.; in if builtins.isFunction tree then tree {} else tree)"
NEW_VERSION=$(nix-instantiate --eval -E "with $importTree; kanata.version" | tr -d '"')
karabinerDriverCrateVersion="$(curl -L "https://raw.githubusercontent.com/jtroo/kanata/refs/tags/v$NEW_VERSION/Cargo.lock" | tomlq | jq --raw-output '.package[] | select(.name |  test("karabiner-driverkit")) |.version')"
newKarabinerDkVersion="$(curl -L "https://crates.io/api/v1/crates/karabiner-driverkit/$karabinerDriverCrateVersion/download" | tar xzvf - --strip-components=1 -O "karabiner-driverkit-$karabinerDriverCrateVersion/c_src/Karabiner-DriverKit-VirtualHIDDevice/version.json" | jq --raw-output0 .package_version)"
oldDarwinVersion=$(nix-instantiate --eval -E "with $importTree; kanata.passthru.darwinDriverVersion" | tr -d '"')
nixFile=$(nix-instantiate --eval --strict -A "kanata.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
sed -i "$nixFile" -re "s|\"$oldDarwinVersion\"|\"$newKarabinerDkVersion\"|"
