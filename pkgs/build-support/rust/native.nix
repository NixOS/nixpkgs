{
  lib,
  libgit2,
}:
{
  # Attr name must be the unprefixed library name
  # libgit2 -> git2
  # The crate name does not matter.
  git2 = {
    # Unprefixed name to link `-lgit2`
    rustc-link-lib = [ "git2" ];
    # Linker search path to add
    rustc-link-search = [ "${libgit2.lib}/lib" ];

    # There are other attriibutes avaliable in the cargo manual.
  };
}
