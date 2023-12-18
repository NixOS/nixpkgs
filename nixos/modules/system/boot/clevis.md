# Clevis {#module-boot-clevis}

[Clevis](https://github.com/latchset/clevis)
is a framework for automated decryption of resources.
Clevis allows for secure unattended disk decryption during boot, using decryption policies that must be satisfied for the data to decrypt.


## Create a JWE file containing your secret {#module-boot-clevis-create-secret}

The first step is to embed your secret in a [JWE](https://en.wikipedia.org/wiki/JSON_Web_Encryption) file.
JWE files have to be created through the clevis command line. 3 types of policies are supported:

1) TPM policies

Secrets are pinned against the presence of a TPM2 device, for example:
```
echo hi | clevis encrypt tpm2 '{}' > hi.jwe
```
2) Tang policies

Secrets are pinned against the presence of a Tang server, for example:
```
echo hi | clevis encrypt tang '{"url": "http://tang.local"}' > hi.jwe
```

3) Shamir Secret Sharing

Using Shamir's Secret Sharing ([sss](https://en.wikipedia.org/wiki/Shamir%27s_secret_sharing)), secrets are pinned using a combination of the two preceding policies. For example:
```
echo hi | clevis encrypt sss \
'{"t": 2, "pins": {"tpm2": {"pcr_ids": "0"}, "tang": {"url": "http://tang.local"}}}' \
> hi.jwe
```

For more complete documentation on how to generate a secret with clevis, see the [clevis documentation](https://github.com/latchset/clevis).


## Activate unattended decryption of a resource at boot {#module-boot-clevis-activate}

In order to activate unattended decryption of a resource at boot, enable the `clevis` module:

```
boot.initrd.clevis.enable = true;
```

Then, specify the device you want to decrypt using a given clevis secret. Clevis will automatically try to decrypt the device at boot and will fallback to interactive unlocking if the decryption policy is not fulfilled.
```
boot.initrd.clevis.devices."/dev/nvme0n1p1".secretFile = ./nvme0n1p1.jwe;
```

Only `bcachefs`, `zfs` and `luks` encrypted devices are supported at this time.
