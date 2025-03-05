{ stdenv, cmake, fetchFromGitHub, fetchpatch, lib }: let
  version = "1.2.3";
in stdenv.mkDerivation {
  pname = "stduuid";
  inherit version;

  src = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "stduuid";
    rev = "v${version}";
    hash = "sha256-MhpKv+gH3QxiaQMx5ImiQjDGrbKUFaaoBLj5Voh78vg=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    # stduuid report version 1.0 instead of 1.2.3 for cmake's find_package to properly work
    # If version is updated one day, this patch will need to be updated
    (fetchpatch {
      url = "https://github.com/OlivierLDff/stduuid/commit/b02c70c0a4bef2c82152503e13c9a67d6631b13d.patch";
      hash = "sha256-tv4rllhngdgjXX35kcM69yXo0DXF/BQ+AUbiC1gJIU8=";
    })
  ];

  meta = {
    description = "C++17 cross-platform implementation for UUIDs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shlevy ];
    homepage = "https://github.com/mariusbancila/stduuid";
    platforms = lib.platforms.all;
  };
}
