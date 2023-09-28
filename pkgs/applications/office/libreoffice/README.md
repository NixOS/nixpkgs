LibreOffice
===========

Here are instructions how to update libreoffice. In the below commands and
instructions, $VARIANT is either `still` or `fresh`.

1. Update the necessary version parts in `src-$VARIANT/primary.nix`.
2. Run the following command:

```bash
nix-shell gen-shell.nix --argstr variant VARIANT --run generate
```

3. It will fail initially, due to hash mismatch in the main `src` attribute.
   Fix the hash according to the failure.
4. Run the command from step 2 again, now it will take a while.
5. Zero-out the hashes of the translations and help attributes in
   `src-$VARIANT/primary.nix`.
6. Update the hashes above by building `libreoffice-$VARIANT`.
