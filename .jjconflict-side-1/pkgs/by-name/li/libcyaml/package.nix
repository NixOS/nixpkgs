{
  stdenv,
  lib,
  fetchFromGitHub,
  libyaml,
}:

stdenv.mkDerivation rec {
  pname = "libcyaml";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = "libcyaml";
    rev = "v${version}";
    hash = "sha256-JIN/cvh9PRl4/K0Z3WZtSCA3casBxyaxNxjXZZdQRWQ=";
  };

  buildInputs = [ libyaml ];

  makeFlags = [
    "VARIANT=release"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/tlsa/libcyaml";
    description = "C library for reading and writing YAML";
    changelog = "https://github.com/tlsa/libcyaml/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
