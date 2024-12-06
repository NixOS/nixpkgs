{ lib, stdenv, fetchFromGitHub, pkg-config, glib, zlib, libpng, cmake, python3 }:

let
  version = "0.3.4";
  pname = "lensfun";

  # Fetch a more recent version of the repo containing a more recent lens
  # database
  lensfunDatabase = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "a1510e6f33ce9bc8b5056a823c6d5bc6b8cba033";
    sha256 = "sha256-qdONyKk873Tq11M33JmznhJMAGd4dqp5KdXdVhfy/Ak=";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "sha256-FyYilIz9ssSHG6S02Z2bXy7fjSY51+SWW3v8bm7sLvY=";
  };

  # replace database with a more recent snapshot
  # the master branch uses version 2 profiles, while 0.3.3 requires version 1 profiles,
  # so we run the conversion tool the project provides,
  # then untar the verson 1 profiles into the source dir before we build
  prePatch = ''
    rm -R data/db
    python3 ${lensfunDatabase}/tools/lensfun_convert_db_v2_to_v1.py $TMPDIR ${lensfunDatabase}/data/db
    mkdir -p data/db
    tar xvf $TMPDIR/db/version_1.tar -C data/db
    date +%s > data/db/timestamp.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.setuptools
    python3.pkgs.lxml # For the db converison
  ];

  buildInputs = [ glib zlib libpng ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ flokli paperdigits ];
    license = lib.licenses.lgpl3;
    description = "Opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}
