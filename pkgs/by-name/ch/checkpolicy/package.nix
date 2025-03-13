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
  version = "3.8";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/checkpolicy-${version}.tar.gz";
    sha256 = "sha256-ZforqKJR1tQvAwZGcU5eLegHrhbgIx3isDuUCq2636U=";
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
