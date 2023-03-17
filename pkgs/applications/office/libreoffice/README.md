LibreOffice
===========

To generate `src-$VARIANT/download.nix`, i.e. list of additional sources that
the libreoffice build process needs to download:

    nix-shell gen-shell.nix --argstr variant VARIANT --run generate

Where VARIANT is either `still` or `fresh`.
