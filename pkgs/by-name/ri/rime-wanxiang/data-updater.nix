{
  writeShellApplication,
  curl,
  jq,
  unzip,
}:

let
  baseDictRelease = {
    url = "https://api.github.com/repos/amzxyz/rime_wanxiang/releases/tags/dict-nightly";
    fileMatch = "base-zh-dicts.zip";
  };

  proDictRelease = {
    url = "https://api.github.com/repos/amzxyz/rime_wanxiang/releases/tags/dict-nightly";
    fileMatch = "pro-all-zh-dicts.zip";
  };

  grammarModelRelease = {
    url = "https://api.github.com/repos/amzxyz/RIME-LMDG/releases/tags/LTS";
    fileMatch = "wanxiang-lts-zh-hans.gram";
  };

in
writeShellApplication {
  name = "rime-wanxiang-data-updater";

  runtimeInputs = [
    curl
    jq
    unzip
  ];

  text = ''
    COMMON_STAGING_DIR="staging"

    BASE_DICT_JOB_NAME="Base Dictionaries"
    BASE_DICT_RELEASE_URL="${baseDictRelease.url}"
    BASE_DICT_FILE_MATCH="${baseDictRelease.fileMatch}"
    BASE_DICT_RELEASE_JSON="base.json"
    BASE_DICT_EXTRACTED_DIR="base_extracted"
    BASE_DICT_STAGING_DIR="$COMMON_STAGING_DIR/zh_dicts"

    PRO_DICT_JOB_NAME="Pro Dictionaries"
    PRO_DICT_RELEASE_URL="${proDictRelease.url}"
    PRO_DICT_FILE_MATCH="${proDictRelease.fileMatch}"
    PRO_DICT_RELEASE_JSON="pro.json"
    PRO_DICT_EXTRACTED_DIR="pro_extracted"
    PRO_DICT_STAGING_DIR="$COMMON_STAGING_DIR/zh_dicts_pro"

    GRAMMAR_JOB_NAME="Grammar Model"
    GRAMMAR_RELEASE_URL="${grammarModelRelease.url}"
    GRAMMAR_FILE_MATCH="${grammarModelRelease.fileMatch}"
    GRAMMAR_RELEASE_JSON="gram.json"
    GRAMMAR_STAGING_DIR="$COMMON_STAGING_DIR"

    VERSION_FILE="versions.json"

    # Mutated by do_download()
    current_file=
    current_file_url=

    # Initialized by passed-in argument
    user_data_dir=

    # Flags
    base_dict_selected=
    pro_dict_selected=
    grammar_selected=

    usage() {
        cat <<EOF
    Usage:
        ''${0##*/} [options] USER_DATA_DIR

    Options:
        -b    Update dictionaries for base version
        -p    Update dictionaries for pro version
        -g    Update grammar model

    USER_DATA_DIR location for common input frameworks:

        squirrel: ~/Library/Rime
        ibus-rime: ~/.config/ibus/rime
        fcitx-rime: ~/.config/fcitx/rime
        fcitx5-rime: ~/.local/share/fcitx5/rime/

    See also: https://github.com/rime/home/wiki/UserData
    EOF
    }

    do_download() {
        name="$1"
        url="$2"
        file_match="$3"
        json="$4"

        printf "Fetching the latest %s..." "$name"
        curl -sL "$url" | jq ".assets | map(select(.name | test(\"$file_match\"))) | first | {name, created_at, updated_at, browser_download_url}" > "$json"
        printf " Done.\n"

        current_file="$(jq -r '.name' "$json")"
        current_file_url="$(jq -r '.browser_download_url' "$json")"

        printf "Downloading %s..." "$name"
        curl -sL -o "$current_file" "$current_file_url"
        printf " Done.\n"
    }

    do_log_version() {
        ! [ -f "$VERSION_FILE" ] && touch "$VERSION_FILE"
        cat "$1" >> "$VERSION_FILE"
    }

    update_base_dict() {
        do_download "$BASE_DICT_JOB_NAME" \
                    "$BASE_DICT_RELEASE_URL" \
                    "$BASE_DICT_FILE_MATCH" \
                    "$BASE_DICT_RELEASE_JSON"

        printf "Staging %s..." "$BASE_DICT_JOB_NAME"

        mkdir -p "$BASE_DICT_EXTRACTED_DIR"
        unzip -q -d "$BASE_DICT_EXTRACTED_DIR" "$current_file"

        mkdir -p "$BASE_DICT_STAGING_DIR"
        mv "$BASE_DICT_EXTRACTED_DIR"/**/*.yaml "$BASE_DICT_STAGING_DIR"

        do_log_version "$BASE_DICT_RELEASE_JSON"

        printf " Done.\n"
    }

    update_pro_dict() {
        do_download "$PRO_DICT_JOB_NAME" \
                    "$PRO_DICT_RELEASE_URL" \
                    "$PRO_DICT_FILE_MATCH" \
                    "$PRO_DICT_RELEASE_JSON"

        printf "Staging %s..." "$PRO_DICT_JOB_NAME"

        mkdir -p "$PRO_DICT_EXTRACTED_DIR"
        unzip -q -d "$PRO_DICT_EXTRACTED_DIR" "$current_file"

        mkdir -p "$PRO_DICT_STAGING_DIR"
        mv "$PRO_DICT_EXTRACTED_DIR"/**/*.yaml "$PRO_DICT_STAGING_DIR"

        do_log_version "$PRO_DICT_RELEASE_JSON"

        printf " Done.\n"
    }

    update_grammar_model() {
        do_download "$GRAMMAR_JOB_NAME" \
                    "$GRAMMAR_RELEASE_URL" \
                    "$GRAMMAR_FILE_MATCH" \
                    "$GRAMMAR_RELEASE_JSON"


        printf "Staging %s..." "$GRAMMAR_JOB_NAME"

        mkdir -p "$GRAMMAR_STAGING_DIR"
        mv "$current_file" "$GRAMMAR_STAGING_DIR"

        do_log_version "$GRAMMAR_RELEASE_JSON"

        printf " Done.\n"
    }

    # Begin processing

    for arg in "$@"; do
        case "$arg" in
            (-b)
                base_dict_selected=1
                ;;
            (-p)
                pro_dict_selected=1
                ;;
            (-g)
                grammar_selected=1
                ;;
            (-h|--help)
                usage
                exit 1
                ;;
            (--*|-*)
                printf "Error: Unknown option %s.\n" "$arg"
                usage
                exit 1
                ;;
            (*)
                user_data_dir="$arg"
                ;;
        esac
    done

    if [ -z "$base_dict_selected" ] \
           && [ -z "$pro_dict_selected" ] \
           && [ -z "$grammar_selected" ]; then
        printf "Error: No option specified.\n"
        usage
        exit 1
    fi

    if ! [ -d "$user_data_dir" ]; then
        printf "Error: User data directory '%s' doesn't exist.\n" "$user_data_dir"
        usage
        exit 1
    fi

    cd "$(mktemp -d)"

    [ -n "$base_dict_selected" ] && update_base_dict
    [ -n "$pro_dict_selected" ] && update_pro_dict
    [ -n "$grammar_selected" ] && update_grammar_model

    printf "Updating files in user data directory: %s ...\n" "$user_data_dir"

    cp -rf "$COMMON_STAGING_DIR"/* "$user_data_dir"
    cat "$VERSION_FILE" >> "$user_data_dir/$VERSION_FILE"

    printf "Successfully updated files.\n"
    printf "Version info is written in: %s\n" "$(ls "$user_data_dir/versions.json" 2>/dev/null)"
  '';
}
