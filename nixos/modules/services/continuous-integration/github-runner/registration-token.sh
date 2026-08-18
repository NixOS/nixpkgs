# shellcheck shell=bash
# Fetch a self-hosted runner registration token from the GitHub API.
#
# Adapted from https://github.com/myoung34/docker-github-actions-runner (MIT,
# Copyright (c) 2020 Marcus Young).
#
# Expects the following environment variables:
#   * ACCESS_TOKEN     a token authorized to manage self-hosted runners
#                      (a GitHub App installation token or a suitable PAT)
#   * RUNNER_SCOPE     one of `org`, `ent` or `repo`
#   * ORG_NAME         the org login (for `org` scope)
#   * ENTERPRISE_NAME  the enterprise slug (for `ent` scope)
#   * REPO_URL         the repository URL (for `repo` scope)
#   * GITHUB_HOST      optional, defaults to github.com (set for GHES)
#
# Prints `{"token": ..., "full_url": ...}` to stdout.

_GITHUB_HOST=${GITHUB_HOST:="github.com"}

# If the host is not github.com, use the GitHub Enterprise Server API endpoint.
if [[ ${_GITHUB_HOST} == "github.com" ]]; then
  URI="https://api.${_GITHUB_HOST}"
else
  URI="https://${_GITHUB_HOST}/api/v3"
fi

API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
AUTH_HEADER="Authorization: token ${ACCESS_TOKEN}"
CONTENT_LENGTH_HEADER="Content-Length: 0"

case ${RUNNER_SCOPE} in
org*)
  _FULL_URL="${URI}/orgs/${ORG_NAME}/actions/runners/registration-token"
  ;;

ent*)
  _FULL_URL="${URI}/enterprises/${ENTERPRISE_NAME}/actions/runners/registration-token"
  ;;

*)
  _PROTO="https://"
  _URL="${REPO_URL/${_PROTO}/}"
  _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"
  _ACCOUNT="$(echo "${_PATH}" | cut -d/ -f1)"
  _REPO="$(echo "${_PATH}" | cut -d/ -f2)"
  _FULL_URL="${URI}/repos/${_ACCOUNT}/${_REPO}/actions/runners/registration-token"
  ;;
esac

RUNNER_TOKEN="$(curl -fsSX POST \
  -H "${CONTENT_LENGTH_HEADER}" \
  -H "${AUTH_HEADER}" \
  -H "${API_HEADER}" \
  "${_FULL_URL}" |
  jq -r '.token')"

echo "{\"token\": \"${RUNNER_TOKEN}\", \"full_url\": \"${_FULL_URL}\"}"
