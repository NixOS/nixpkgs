{ stdenv, fetchFromGitHub
, cmake, pkgconfig, autoconf, automake, libtool
, boost, openssl, ncurses, readline
, perl, doxygen, python3
#, zlib, bzip2, snappy # not currently in use; aren't truly needed by lib?
}:
let

  version = "0.20.6";

  # These values are embedded into the respective binaries, but don't appear to be crucial.
  rev = "5d0a4327a22160eea8f1ffe5a7bad7c5ed813ac8";
  revDate = "Wed Oct 24 10:51:32 2018";
  sha256 = "1ylhp74myxy2ixlxrj8pfm0vfby15hzzr85ymwmlc0vba4si6in0";
  fcRev = "EmbeddedInSteemRepo";
  fcRevDate = revDate;

  pythonJinja = python3.withPackages (pypkgs: [pypkgs.jinja2]);

in stdenv.mkDerivation {

  name = "steem-${version}";

  src = fetchFromGitHub {
    owner = "steemit";
    repo = "steem";
    inherit rev sha256;
  };

  buildInputs = [
    cmake
    pkgconfig # libraries/fc/vendor/secp256k1-zkp uses this, not the parent project
    boost openssl ncurses readline
    perl doxygen pythonJinja
    #zlib bzip2 snappy # TODO probably ok without, but could still be included properly
  ];
  nativeBuildInputs = [ autoconf automake libtool ];

  patches = [
    # #undef "major" and "minor", since they collide with some #included GNU lib
    ./undef_major_minor.patch
  ];
  postPatch = ''
    sed -ri "s|PYTHONPATH=|PYTHONPATH=$PYTHONPATH:|" \
      libraries/jsonball/CMakeLists.txt \
      libraries/manifest/CMakeLists.txt

    # Skip these tests, because of main-redefined-link and other errors
    sed -ri "s|^[[:space:]]*add_subdirectory\([[:space:]]*tests?[[:space:]]*\)||" \
      CMakeLists.txt \
      libraries/fc/CMakeLists.txt \
      libraries/chainbase/CMakeLists.txt

    # Inject #defines normally sourced from git
    substituteInPlace libraries/utilities/git_revision.cpp.in \
      --subst-var-by STEEM_GIT_REVISION_SHA "${rev}" \
      --subst-var-by STEEM_GIT_REVISION_UNIX_TIMESTAMP $(date -d "${revDate}" +%s) \
      --subst-var-by STEEM_GIT_REVISION_DESCRIPTION "hardcoded steem description"
    substituteInPlace libraries/fc/src/git_revision.cpp.in \
      --subst-var-by FC_GIT_REVISION_SHA "${fcRev}" \
      --subst-var-by FC_GIT_REVISION_UNIX_TIMESTAMP $(date -d "${fcRevDate}" +%s)

    # There's a build script in here that generates something based on the
    # DoxyDocs.pm module that is built beforehand. This will allow the module
    # to be found by the script.
    PERL5LIB="$PERL5LIB''${PERL5LIB:+:}."
  '';

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF" # boost is not detected, without this

    # These are for some sublib and can safely(?) be turned off
    #"-DSNAPPY_ROOT_DIR=${snappy}" # Defining them like this doesn't work, for some reason
    "-DWITH_SNAPPY=OFF"
    "-DWITH_ZLIB=OFF"
    "-DWITH_BZ2=OFF"
  ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=misleading-indentation" ];

  meta = with stdenv.lib; {
    description = "Blockchain for Smart Media Tokens (SMTs) and decentralized applications";
    longDescription= ''
      Steem is the first blockchain which introduced the "Proof of Brain"
      social consensus algorithm for token allocation.
      Being one of the most actively developed blockchain projects currently in
      existence, it's become fertile soil for entrepreneurial pursuits. It has
      also become home for many cryptocurrency centric projects.
      Steem aims to be the preferred blockchain for dApp development with Smart
      Media Tokens at its core. With SMTs, everyone can leverage the power of
      Steem.
    '';
    homepage = https://steem.com;
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
  };

}
