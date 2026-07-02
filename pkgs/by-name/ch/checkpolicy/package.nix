{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  libsepol,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "checkpolicy";
  version = "3.10";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/checkpolicy-${finalAttrs.version}.tar.gz";
    hash = "sha256-LZKVHfywkNYXnnojhWYi4Py8Mr4Dvx5grOncnL2hHlk=";
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
})
