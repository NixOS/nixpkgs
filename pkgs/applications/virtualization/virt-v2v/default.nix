{ lib, stdenv, /*fetchFromGitHub,*/ fetchgit, autoreconfHook, pkg-config
, cdrkit, xorriso, libguestfs, libnbd, pcre2, libvirt, libxml2, jansson
, libosinfo, gobject-introspection, ocamlPackages
}:

stdenv.mkDerivation rec {
  pname = "virt-v2v";
  version = "2.3.4";

  #src = fetchFromGitHub {
  #  owner = "libguestfs";
  #  repo = pname;
  #  rev = "refs/tags/v${version}";
  #  hash = "sha256-PJbeLmc8EX+4d2GNBXX2Rtmrm3g8m459j+J4OC1m/tA=";
  #};

  # Use fetchgit for submodules (which are missing with fetchFromGitHub).
  src = fetchgit {
    url = "https://github.com/libguestfs/virt-v2v";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-FtsrbY8ER5KQFUx2x3SqmP9lXyVu5USrjLogagCjJjY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  # TODO: Consider taking all inputs from libguestfs?
  buildInputs = [
    # Needs xorriso, genisoimage or mkisofs -- xorriso chosen for closure size (MOVE THIS COMMENT INTO THE COMMIT MESSAGE)
    # FIXME: Maybe use cdrkit anyway, because it's an input to libguestfs?
    xorriso

    libguestfs
    libnbd
    pcre2
    libvirt
    libxml2
    jansson
    libosinfo
    gobject-introspection
    ocamlPackages.ocaml
    ocamlPackages.findlib
    ocamlPackages.ocaml_libvirt
    #ocamlPackages.libnbd  # FIXME: missing
  ];

  meta = {
    description = "Convert guests from foreign hypervisors to run on KVM";
    # TODO: more meta attrs.
  };
}
