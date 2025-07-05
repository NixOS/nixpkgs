{
  writeShellApplication,
  curl,
  jq,
  unzip,
  isProVersion ? false,
}:

let
  grammarModelRelease = {
    url = "https://api.github.com/repos/amzxyz/RIME-LMDG/releases/tags/LTS";
    fileMatch = "wanxiang-lts-zh-hans.gram";
  };

  basicDictRelease = {
    url = "https://api.github.com/repos/amzxyz/rime_wanxiang/releases/tags/dict-nightly";
    fileMatch = "cn_dicts.zip";
  };

  proDictRelease = {
    url = "https://api.github.com/repos/amzxyz/rime_wanxiang_pro/releases/tags/dict-nightly";
    fileMatch = "cn_dicts.zip";
  };

  updaterName = "update-rime-wanxiang${if isProVersion then "-pro-" else "-"}dict";
  dictRelease = if isProVersion then proDictRelease else basicDictRelease;

in
writeShellApplication {
  name = updaterName;
  runtimeInputs = [
    curl
    jq
    unzip
  ];
  text = ''
    set -e

    if [ $# -lt 1 ]; then
        cat <<EOF
    Usage:
        ''${0##*/} USER_DATA_DIR

    User data directory location for common input frameworks:

        squirrel: ~/Library/Rime
        ibus-rime: ~/.config/ibus/rime
        fcitx-rime: ~/.config/fcitx/rime
        fcitx5-rime: ~/.local/share/fcitx5/rime/

    See also: https://github.com/rime/home/wiki/UserData
    EOF
        exit 1
    fi

    user_data_dir="$1"

    cd "$(mktemp -d)"

    printf "Fetching the latest dictionary release..."
    curl -sL "${dictRelease.url}" | jq '.assets | map(select(.name | test("${dictRelease.fileMatch}"))) | first | {name, created_at, updated_at, browser_download_url}' > dict.json
    printf " Done.\n"

    printf "Fetching the latest grammar model release..."
    curl -sL "${grammarModelRelease.url}" | jq '.assets | map(select(.name | test("${grammarModelRelease.fileMatch}"))) | first | {name, created_at, updated_at, browser_download_url}' > gram.json
    printf " Done.\n"

    dict_file="$(jq -r '.name' dict.json)"
    dict_url="$(jq -r '.browser_download_url' dict.json)"
    lm_file="$(jq -r '.name' gram.json)"
    lm_url="$(jq -r '.browser_download_url' gram.json)"

    printf "Downloading the latest dictionaries..."
    curl -sL -o "$dict_file" "$dict_url"
    printf " Done.\n"

    printf "Downloading the latest grammar model..."
    curl -sL -o "$lm_file" "$lm_url"
    printf " Done.\n"

    printf "Staging files..."

    mkdir extracted_dict
    unzip -q -d extracted_dict "$dict_file"

    mkdir -p staging/cn_dicts
    mv extracted_dict/**/*.yaml staging/cn_dicts
    mv "$lm_file" staging/
    echo "{ \"dict\": $(cat dict.json), \"grammar_model\": $(cat gram.json)}" | jq '.' > staging/versions.json

    printf " Done.\n"

    printf "Updating files in the user data directory: %s ...\n" "$user_data_dir"

    mkdir -p "$user_data_dir/cn_dicts"
    cp -rf staging/* "$user_data_dir"

    printf "Successfully updated dictionaries and grammar model.\n"
    printf "Version info is stored in: %s\n" "$(ls "$user_data_dir/versions.json" 2>/dev/null)"
  '';
}
