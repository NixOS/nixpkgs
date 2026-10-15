#!/usr/bin/env nix-shell
#!nix-shell -i zsh -p zsh
set -euo pipefail

# cd into nixpkgs' root, get the store path of `systemd.man`
cd "$(dirname "$0")/../../.."
SYSTEMD_MAN_DIR="$(nix-build -A systemd.man)/share/man"

# For each manual section
for section in {1..8}; do
  sec_dir="${SYSTEMD_MAN_DIR}/man${section}"

  # skip section 3 (library calls)
  ! [[ $section -eq 3 ]] || continue

  # for each manpage in that section (potentially none)
  for manpage in ${sec_dir}/*(N); do
    # strip the directory prefix and (compressed) manpage suffix
    page="$(basename "$manpage" ".${section}.gz")"

    # if this is the manpage of a service unit
    if [[ "$page" =~ ".*\.service" ]]; then
     # ... and a manpage exists without the `.service` suffix
     potential_alias="${sec_dir}/${page%\.service}.${section}.gz"
     ! [[ -e "${potential_alias}" &&
              # ... which points to the same file, then skip
              "$(gunzip -c "${potential_alias}")" == ".so ${page}.${section}" ]] || continue
    fi

    # else produce a JSON fragment, with the link to the upstream manpage (as HTML)
    echo "  \"${page}(${section})\": \"https://www.freedesktop.org/software/systemd/man/${page}.html\","
  done
done
