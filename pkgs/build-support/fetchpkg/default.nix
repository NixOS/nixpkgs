# This function downloads and unpacks a Darwin package file.
# This is primarily useful for binary applications distributed as
# a pkg file.

{
  fetchdmg,
  libarchive,
}:

{
  ...
}@args:

fetchdmg (
  args
  // {
    nativeBuildInputs = [ libarchive ];

    # Extract files from Payload or Payload~ file contained in given pkg if any.
    # N.B.: Depending on how apps are packaged maxdepth might need to be adjusted
    # or made adjustable
    postFetch = ''
      find . -name 'Payload*' -maxdepth 2 -print0 \
        | xargs -0 -t -I % bsdtar -xf %
    '';
  }
)
