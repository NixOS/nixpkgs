{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dyncall";
  version = "1.4";

  src = fetchurl {
    url = "https://www.dyncall.org/r${version}/dyncall-${version}.tar.gz";
    # https://www.dyncall.org/r1.4/SHA256
    sha256 = "sha256-FEN9u+87bckkg/ZQfq+CWrl5ZKie7K6Ms0emvsnDKq4=";
  };

  # XXX: broken tests, failures masked, lets avoid crashing a bunch for now :)
  doCheck = false;

  # install bits not automatically installed
  postInstall = ''
    # install cmake modules to make using dyncall easier
    # This is essentially what -DINSTALL_CMAKE_MODULES=ON if using cmake build
    # We don't use the cmake-based build since it installs different set of headers
    # (mostly fewer headers, but installs dyncall_alloc_wx.h "instead" dyncall_alloc.h)
    # and we'd have to patch the cmake module installation to not use CMAKE_ROOT anyway :).
    install -D -t $out/lib/cmake ./buildsys/cmake/Modules/Find*.cmake

    # manpages are nice, install them
    # doing this is in the project's "ToDo", so check this when updating!
    install -D -t $out/share/man/man3 ./*/*.3
  '';

  meta = with lib; {
    description = "Highly dynamic multi-platform foreign function call interface library";
    homepage = "https://www.dyncall.org";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
