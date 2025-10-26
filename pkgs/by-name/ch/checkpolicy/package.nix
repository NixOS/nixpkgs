{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  libsepol,
}:

stdenv.mkDerivation rec {
  pname = "checkpolicy";
  version = "3.8.1";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/checkpolicy-${version}.tar.gz";
    sha256 = "sha256-e0d8UW4mk9i2xRE4YyMXfx19tRwuBOttDejKKzYSDl0=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];
  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta =
    removeAttrs libsepol.meta [
      "outputsToInstall"
      "name"
    ]
    // {
      description = "SELinux policy compiler";
      mainProgram = "checkpolicy";
    };
}
