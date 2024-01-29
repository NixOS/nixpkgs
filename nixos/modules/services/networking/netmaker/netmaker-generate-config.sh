#!/usr/bin/env bash
set -eEuo pipefail

info() {
    echo "$@" >&2
}

make_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c "$1"
}

save_config() {
    save_value "${ENV_FILE}" "$@"
}

save_secret() {
    save_value "${SECRETS_FILE}" "$@"
}

save_value() {
    # loosely based on https://github.com/gravitl/netmaker/blob/dd5a943fa473ad21830133fb1b83421a7ab61a16/scripts/nm-quick.sh#L454-L480
    local FILE="$1" NAME="$2" VALUE
    if test "$#" -ge 3; then
        VALUE="$3"
    else
        VALUE="${!NAME:-""}"
    fi
    # escape | in the value
    VALUE="${VALUE//|/"\|"}"
    # escape single quotes
    VALUE="${VALUE//"'"/\'\"\'\"\'}"
    # single-quote the value
    VALUE="'${VALUE}'"
    if grep -q "^$NAME=" "$FILE"; then
        sed -i "s|$NAME=.*|$NAME=$VALUE|" "$FILE"
    else
        echo "$NAME=$VALUE" >>"$FILE"
    fi
}

ensure_mq_password() {
    if test -z "${MQ_PASSWORD:-}" && test -e "${MQ_PASSWORD_FILE}"; then
        MQ_PASSWORD="$(cat "${MQ_PASSWORD_FILE}")"
    fi
    if test -z "${MQ_PASSWORD:-}"; then
        MQ_PASSWORD="$(make_password 30)"
    fi

    save_secret "MQ_PASSWORD"
    mkdir -p "${MQ_PASSWORD_FILE%/*}"
    echo -n "${MQ_PASSWORD}" >"${MQ_PASSWORD_FILE}"
}

ensure_master_key() {
    if test -z "${MASTER_KEY:-}"; then
        MASTER_KEY="$(make_password 30)"
        save_secret "MASTER_KEY"
    fi
}

configure() {
    ensure_mq_password
    ensure_master_key
}

configure
if test "$#" -gt 0; then
    exec "$@"
fi
