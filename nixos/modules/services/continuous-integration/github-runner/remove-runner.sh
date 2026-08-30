# shellcheck shell=bash
# Force-remove a previously registered, offline self-hosted runner via the
# GitHub API. Used before re-registering to avoid orphaned runners piling up in
# the GitHub Actions UI.
#
# Adapted from https://github.com/myoung34/docker-github-actions-runner (MIT,
# Copyright (c) 2020 Marcus Young).
#
# Expects the following environment variables:
#   * ACCESS_TOKEN     a token authorized to manage self-hosted runners
#   * RUNNER_NAME      the name of the runner to remove
#   * RUNNER_SCOPE     one of `org`, `ent` or `repo`
#   * ORG_NAME         the org login (for `org` scope)
#   * ENTERPRISE_NAME  the enterprise slug (for `ent` scope)
#   * REPO_URL         the repository URL (for `repo` scope)
#   * GITHUB_HOST      optional, defaults to github.com (set for GHES)

_GITHUB_HOST=${GITHUB_HOST:="github.com"}

# If the host is not github.com, use the GitHub Enterprise Server API endpoint.
if [[ ${_GITHUB_HOST} == "github.com" ]]; then
  URI="https://api.${_GITHUB_HOST}"
else
  URI="https://${_GITHUB_HOST}/api/v3"
fi

API_HEADER="Accept: application/vnd.github+json"
AUTH_HEADER="Authorization: token ${ACCESS_TOKEN}"
CONTENT_LENGTH_HEADER="Content-Length: 0"

runners_url() {
  case ${RUNNER_SCOPE} in
  org*)
    echo "${URI}/orgs/${ORG_NAME}/actions/runners"
    ;;
  ent*)
    echo "${URI}/enterprises/${ENTERPRISE_NAME}/actions/runners"
    ;;
  *)
    _PROTO="https://"
    _URL="${REPO_URL/${_PROTO}/}"
    _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"
    _ACCOUNT="$(echo "${_PATH}" | cut -d/ -f1)"
    _REPO="$(echo "${_PATH}" | cut -d/ -f2)"
    echo "${URI}/repos/${_ACCOUNT}/${_REPO}/actions/runners"
    ;;
  esac
}

_RUNNERS_URL="$(runners_url)"

RUNNERS="$(curl -fsSX GET \
  -H "${CONTENT_LENGTH_HEADER}" \
  -H "${AUTH_HEADER}" \
  -H "${API_HEADER}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${_RUNNERS_URL}")"
RUNNER_ID=$(echo "$RUNNERS" | jq -r '.runners[] | select( (.name == env.RUNNER_NAME) and (.status == "offline") ) | .id')

if [[ $RUNNER_ID == "" ]]; then
  echo "Runner ${RUNNER_NAME} doesn't exist or is online. Nothing to unregister."
  exit 0
fi
echo "${RUNNER_NAME} is still registered and offline. Forcing removal..."

curl -fsSX DELETE \
  -H "${CONTENT_LENGTH_HEADER}" \
  -H "${AUTH_HEADER}" \
  -H "${API_HEADER}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${_RUNNERS_URL}/${RUNNER_ID}"
