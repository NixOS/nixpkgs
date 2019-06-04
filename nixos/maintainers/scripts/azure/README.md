# nixos/azure

#### Create & Upload "Official" Images

1. Update `<nixpkgs>/nixos/modules/virtualisation/azure-images.nix`, as appropriate.
2. From `<nixpkgs>/nixos/maintainers/scripts/azure`, run `./images-ensure.vhd`. This will ensure all images are built and re-upload them all.
3. You should manually update `azure-images.nix` with the uploaded image URLs.

```bash
nvim ./../../../modules/virtualisation/azure-images.nix
export AZURE_SUBSCRIPTION_ID="<production NixOS subscription ID>"
export AZURE_RESOURCE_GROUP="NIXOS_PRODUCTION"
export AZURE_STORAGE_ACCOUNT="nixosofficial"
./az.sh login
./images-ensure.vhd
```


#### Verifying Image

```bash
# ./az.sh wraps the Azure CLI using Docker (azure-cli isn't packaged for nixpkgs)
./az.sh login

# Choose URL from `azure-images.nix`.
# Copy the VHD to your own subscription/location.
$ ./mkimage.sh copy "https://nixos0westus2aff271ee.blob.core.windows.net/vhds/nixos-image-19.09.git.cmpkgs3-x86_64-linux.vhd"
...
/subscriptions/aff271ee-e9be-4441-b9bb-42f5af4cbaeb/resourceGroups/NIXOS_PRODUCTION/providers/Microsoft.Compute/images/nixos-image-19.09.git.cmpkgs3-x86_64-linux.vhd

# Boot a VM from the image (template) you've created.
$ ./mkvm.sh "/subscriptions/aff271ee-e9be-4441-b9bb-42f5af4cbaeb/resourceGroups/NIXOS_PRODUCTION/providers/Microsoft.Compute/images/nixos-image-19.09.git.cmpkgs3-x86_64-linux.vhd"
...
{
  "fqdns": "vm-22389.westus2.cloudapp.azure.com",
  "id": "/subscriptions/.../resourceGroups/rg/providers/Microsoft.Compute/virtualMachines/vm-22389",
  "location": "westus2",
  "macAddress": "00-0D-3A-F9-67-85",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "52.250.109.186",
  "resourceGroup": "rg",
  "zones": ""
} 
```

#### Custom Image

You can chain these commands too, neat!

```bash
$ cd ./custom-image-example/

$ out="$(nix-build custom-image-example/default.nix -A machine.config.system.build.azureImage --no-out-link)"
$ imageid="$(./mkimage.sh upload "${out}")"
$ ./mkvm.sh "${imageid}"
...
{
  ...
  "publicIpAddress": "52.250.109.186",
}
```

### Background

This functionality is somewhat non-trivial. It handles:
1. creating *any and all* necessary missing resources
2. replicating the specified VHD blob to your own storage account/location
3. automatic unique naming per all of Azure's contraints: supports multi-region, multi-replica, multi-subscription magic, meaning it should "just work" out of the box, and the official account will be simply be official by naturing of living in the orificial NixOS storage account (identifiable by part of the storage account identifier which is present in the final VHD URI).)


### NixOS Administrative Notes:

We should:

1. Make sure a few people have public-dir Azure accounts.
2. Add them all to the RG that contains the SA, etc.
3. Make sure at least two people remember that (1) they have access, (2) their microsoft account logins.

