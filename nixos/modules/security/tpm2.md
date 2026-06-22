# TPM2 {#module-security-tpm2}

## Introduction {#module-security-tpm2-introduction}

The `tpm2` module allows configuration of a number of programs and services associated with the use of a Trusted Platform Module (TPM).
A TPM is a hardware or firmware device that can be useful for security purposes.
One thing you can do with a TPM is to instruct it to create cryptographic keys which reside inside the TPM hardware, and which cannot be exported, not even to the computer hosting the TPM.
To make those keys useful, the TPM also exposes operations that you can perform using the keys.
So for instance, you can instruct the TPM to encrypt a piece of data using a cryptographic key protected by the TPM, or cryptographically sign a piece of data using a cryptographic key protected by the TPM.

A key stored directly on the TPM is called a resident key.
Because the TPM has very limited storage, it's common to work with another kind of key, called a wrapped key.
When you instruct the TPM to create a wrapped key, it creates a new key, encrypts the secret material using a key stored directly on the TPM, and returns the encrypted secret material along with some metadata to the user, in a file called the key context.
The TPM also supports operations where you provide it with the key context along with whatever you want to encrypt or sign, and it will unwrap the key and do the operation.

Another important concept is attestation.
The idea is that the user of a TPM may want to prove to a third party that a particular key is protected by the TPM hardware.
This is typically done by the manufacturer or distributor of the TPM hardware prior to distribution to the end user, and involves creating a resident key on the TPM, along with a certificate for that key signed by the manufacturer's or distributor's key.
The user can then provide the certificate to the third party along with the public portion of the resident key to prove that the key is protected by the TPM.

Most physical TPMs come with one resident key that also has a certificate.
This key is known as the Endorsement Key, or EK, and the certificate is known as the EK Certificate.
For applications where you want to be able to prove properties of a key to third parties, you will want a key that is wrapped by the EK.
Such keys are described as residing in the Endorsement Hierarchy.
If you do not require attestation, you will generally wrap your keys with the storage root key (SRK).
Such keys are described as residing in the Storage Hierarchy, or the Owners Hierarchy.

### Software Architecture {#module-security-tpm2-introduction-softwarearchitecture}

#### TCTI {#module-security-tpm2-introduction-softwarearchitecture-tcti}

TPM hardware uses a binary protocol called the TPM Command Transmission Interface, or TCTI, to communicate with the host computer.
The TPM kernel driver exposes a character device, typically `/dev/tpm0`, and one way of interacting with the TPM is to read and write the TCTI protocol to that device.
Of course doing that directly in your own code would be quite laborious, and there are a number of software libraries and programs that can help you do it.
The lowest level of these is C library called ESAPI, located inside the `tpm2-tss` package.

#### Resource Managers {#module-security-tpm2-introduction-resourcemanagers}

Another thing you need to know is that the TPM is a stateful device: operations can affect its state, and it's common to perform a sequence of operations where early operations modify the state, and later operations depend on that state to do other operations.
For instance, you may load a wrapped key to a particular storage location, then do an encryption operation using that loaded key.
This makes multi-user access challenging, as two users may modify the state in incompatible ways.
The solution to this is to use a resource manager.
The resource manager can handle multiple different sessions, keep track of the accumulated state of each session, and load and unload state as necessary to interleave multiple different sessions.
There are two resource managers available in the software stack surrounding the TPM: a kernel-space resource manager, and a user-space resource manager.

The kernel-space resource manager is exposed via the tpmrm subsystem.
You can see more info about that subsystem in the sysfs at `/sys/class/tpmrm`.
In a typical system you will also see a `/dev/tpmrm0` device, but it is possible to give it a different name.

The user-space resource manager is contained in the `tpm2-abrmd` package.
It is also frequently referred to as `tabrmd`.

Both resource managers are designed so that they use the same TCTI protocol as a raw tpm device.
For the kernel RM, you access it via a character device (typically `/dev/tpmrm0`).
For the userspace RM, you access it over DBUS.
It is common to refer to a component that is on the "receiving" or "server" side of the TCTI protocol as "a TCTI".
So the raw tpm character device, the kernel RM, and `tabrmd` are all "TCTIs".

The ESAPI library speaks the client side of the TCTI protocol, and can be connected to any server TCTI.
All of the other libraries or programs that work with TPM all use ESAPI under the hood, and so a common characteristic among all these libraries is that you will find you need to configure them in some way as to which TCTI they should be talking to.

#### Higher Level Interfaces {#module-security-tpm2-introduction-hli}

As alluded to previously, there are a number of ways of speaking the client side TCTI that all amount to wrappers around ESAPI. They include:
* FAPI - a C library with an easier API for managing cryptographic algorithms and keys, contained in the `tpm2-tss` package.
* pytss - a python library that wraps ESAPI and FAPI. Contained in the `tpm2-pytss` package.
* tpm2 tools - a command line interface exposed through the programs `tpm2`, which roughly corresponds to the ESAPI, and `tss2` which roughly corresponds to FAPI. Contained in the `tpm2-tools` package.
* pkcs11 - libraries that wrap TPM functionality into a pkcs11 interface. There are variants for the ESAPI, and the FAPI. See the `tpm2-pkcs11`, `tpm2-pkcs11-esapi` and `tpm2-pkcs11-fapi` packages.
* TPM2 OpenSSL - an OpenSSL provider allowing openssl to use the TPM as its cryptographic engine.


## Using the tpm2 NixOS module {#module-security-tpm2-nixosmodule}

A typical configuration is:
```
security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;

    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "tabrmd";
}
```
`enable = true;` is required for any tpm functionality other than the raw character device and kernel resource manager to be available.

`abrmd.enable = true;` causes the tpm2-abrmd program (the user-space resource manager) to run as a systemd service.
Generally you want this because the user-space resource manager gets more frequent updates than the kernel-space RM, and there aren't any kernel RM features that are unavailable in the user-space RM.

`pkcs11.enable = true;` makes the PKCS11 tool and libraries available in the system path.
Generally you want this because it's unlikely to cause problems and it's required by one of the more common TPM use cases, which is protecting an ssh key using the TPM.

`tctiEnvironment.enable = true;` and `tctiEnvironment.interface = "tabrmd";` causes the TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI environment variables to be set properly to use the user-space resource manager.
In other words, it configures all users to use the user-space resource manager for tpm2 tools and tpm2 pkcs11 by default.

### FAPI Configuration {#module-security-tpm2-nixosmodule-fapiconfiguration}

A reasonable FAPI config file is shipped by default and available in `/etc/tpm2-tss/fapi-config.json`.
The `tss2` command line utility in `tpm2-tools` will use this file by default.
If you wish to customize it, you can do so like this:

```
security.tpm2.fapi = {
    profileName = "P_RSA2048SHA256";
};
```

This example changes the cryptographic profile from the default P_ECCP256SHA256 to P_RSA2048SHA256.
The profiles specify a number of algorithmic details, but the short version is that P_ECCP256SHA256 uses elliptic curve cryptography over the NIST P256 curve and SHA256 for hashes, while P_RSA2048SHA256 uses RSA 2048 bit keys and SHA256 for hashes.

Probably the most likely option you may want to use in the FAPI config would be `ekCertLess`.
If set to `null` (the default) or `false`, then FAPI calls will fail if the TPM does not have an EK certificate.
Most TPMs that come with physical computers will have an EK cert, so the default setting would not be a problem.
However, virtual TPMs may not have an EK certificate.
For instance, the Nitro TPM provided on some Amazon Web Services virtual machines does not come with an EK Cert.
In such cases, you may wish to set `ekCertLess = true;` so that FAPI is usable without an EK cert.
