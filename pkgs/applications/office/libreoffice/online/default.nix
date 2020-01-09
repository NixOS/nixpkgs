{ stdenv, pkgs, lib, fetchgit
, libpng, poco, libcap, cppunit, pam, openssl, pcre
, autoconf, automake, libtool, pkgconfig
, python3, nodejs, git

, version ? "7.0.1.1"
, rev ? "libreoffice-7.0.1.1"
, sha256 ? "1ypglwhap4mhrz48h8xglz6qkmv8rcxgi8jhsvckryph3n7ci8gw"
, libreoffice-core ? pkgs.libreoffice-fresh-unwrapped
, loleafletDeps ? import ./loleaflet-deps.nix

# Path to LibreOffice installation that is hardlinked to chroots (i.e. directories under
# /var/lib/lool/child-roots). If we use ${libreoffice-core}/lib/${libreoffice-core.pname}
# then hardlinking is not possible and loolwsd falls back to copying the directory which
# slows down chroot creation (=opening a document) and uses more disk space.
, loPath ? "/var/lib/lool/lotemplate"
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ lxml polib ]);
  nodePackages = loleafletDeps {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
  nodeModules = nodePackages.package;
in stdenv.mkDerivation rec {
  pname = "libreoffice-online";
  inherit version;

  # WARNING(2019-11-19): make sure the source directory has .git subdirectory
  # or dist_git_hash (tarballs from https://dev-www.libreoffice.org/online/ - not from github releases)
  # otherwise loleaflet.html 404s
  # See also https://www.libreoffice.org/about-us/source-code/
  src = fetchgit {
    url = "git://anongit.freedesktop.org/libreoffice/online";
    leaveDotGit = true;
    inherit rev sha256;
  };

  patches = [
    # add ability to pass path to capability wrapper
    ./loolforkit-env-path.patch
  ];

  separateDebugInfo = true;

  preConfigure = ''
    patchShebangs .
    substituteInPlace configure.ac \
      --replace '/bin:' ${libcap}/bin: \
      --replace '/usr/bin/env python3' ${pythonEnv}/bin/python3

    # Tests currently fail to link with with libstdc++fs and more work
    # is probably needed as they e.g. try to run fc-cache.
    substituteInPlace Makefile.am --replace 'SUBDIRS = . test loleaflet' 'SUBDIRS = . loleaflet'

    # npm install fails in NixOS build sandbox so we build loleaflet using node2nix instead.
    substituteInPlace loleaflet/Makefile.am \
       --replace '@npm install' 'echo "skipping npm install for NixOS"' \
       --replace 'node_modules: npm-shrinkwrap.json' 'node_modules:'
    cp -r ${nodeModules}/lib/node_modules/loleaflet/node_modules loleaflet/node_modules
    ./autogen.sh
  '';

  postConfigure = ''
    rm loleaflet/npm-shrinkwrap.json
    mkdir systemplate
    touch systemplate/system-stamp
  '';

  # Please note: if the 10 concurrent documents and 20 connections limit is removed, you may need
  # to change the name of the project (to not include LibreOffice or Collabora), especially if you
  # intend to make it available outside your organisation.
  # see https://www.libreoffice.org/download/libreoffice-online/ or TDF's trademark policy
  configureFlags = [
    "--enable-silent-rules"
    "--with-lokit-path=${libreoffice-core.dev}/include"
    "--with-lo-path=${loPath}"
    "--disable-setcap" # we need to use NixOS wrapper instead
    "--enable-anonymization"
  ];

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig
    libcap nodejs pythonEnv git nodeModules
  ];

  buildInputs = [
    libpng poco cppunit pam openssl pcre
  ];

  passthru = {
    libreoffice = libreoffice-core;
  };

  meta = with lib; {
    description = "Office suite in your web browser";
    homepage = "https://www.libreoffice.org/download/libreoffice-online/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mmilata ];
    platforms = platforms.linux;
  };
}
