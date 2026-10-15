#!/usr/bin/env bash
set -euo pipefail
set -x

image="${1}"
location="westus2"
group="nixos-test-vm"
vm_size="Standard_D2s_v3";  os_size=42;

# ensure group
az group create --location "westus2" --name "${group}"
group_id="$(az group show --name "${group}" -o tsv --query "[id]")"

# (optional) identity
if ! az identity show -n "${group}-identity" -g "${group}" &>/dev/stderr; then
  az identity create --name "${group}-identity" --resource-group "${group}"
fi

# (optional) role assignment, to the resource group, bad but not really great alternatives
identity_id="$(az identity show --name "${group}-identity" --resource-group "${group}" -o tsv --query "[id]")"
principal_id="$(az identity show --name "${group}-identity" --resource-group "${group}" -o tsv --query "[principalId]")"
until az role assignment create --assignee "${principal_id}" --role "Owner" --scope "${group_id}"; do sleep 1; done

# boot vm
az vm create \
  --name "${group}-vm" \
  --resource-group "${group}" \
  --assign-identity "${identity_id}" \
  --size "${vm_size}" \
  --os-disk-size-gb "${os_size}" \
  --image "${image}" \
  --admin-username "${USER}" \
  --location "westus2" \
  --storage-sku "Premium_LRS" \
  --ssh-key-values "$(ssh-add -L)"

