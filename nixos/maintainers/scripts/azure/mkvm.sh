#!/usr/bin/env bash
set -euo pipefail

function az() { ./az.sh "${@}" --subscription "${AZURE_SUBSCRIPTION_ID}"; }

export AZURE_HOSTNAME="xx${AZURE_HOSTNAME:-"nixos-${RANDOM}"}"
export AZURE_LOCATION="${AZURE_LOCATION:="westus2"}"
export AZURE_SIZE="${AZURE_SIZE:-"Standard_D4s_v3"}"
export AZURE_RESOURCE_GROUP="${AZURE_HOSTNAME}-${AZURE_LOCATION}"
export AZURE_SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID:-"aff271ee-e9be-4441-b9bb-42f5af4cbaeb"}" 

sshpubkey="$(ssh-add -L)"
imgid="${1}"

az group create \
  --location "${AZURE_LOCATION}" \
  --name "${AZURE_RESOURCE_GROUP}"

export AZURE_USER="${USER}"
[[ "${AZURE_USER}" == "root" ]] && export AZURE_USER="azureuser"
export AZURE_PASSWORD="${AZURE_PASSWORD:-"TheN!x0sL0r!s"}"

az vm create \
  --resource-group "${AZURE_RESOURCE_GROUP}" \
  --location "${AZURE_LOCATION}" \
  --name "${AZURE_HOSTNAME}" \
  --image "${imgid}" \
  --size "${AZURE_SIZE}" \
  --os-disk-size-gb "50" \
  --storage-sku "Premium_LRS" \
  --os-disk-caching "ReadWrite" \
  --admin-username "${AZURE_USER}" \
  --admin-password "${AZURE_PASSWORD}" \
  --ssh-key-value "${sshpubkey}" \
  --public-ip-address-allocation "static" \
  --public-ip-address-dns-name "${AZURE_HOSTNAME}"
