{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  help2man,
  irods,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "irods-icommands";
  inherit (irods) version;

  src = fetchFromGitHub {
    owner = "irods";
    repo = "irods_client_icommands";
    tag = finalAttrs.version;
    hash = "sha256-lo1eCI/CSzl7BJWdPo7KKVHfznkPN6GwsiQThUGuQdw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    help2man
  ];

  buildInputs = [ irods ];

  cmakeFlags = irods.commonCmakeFlags ++ [
    (lib.cmakeFeature "ICOMMANDS_INSTALL_DIRECTORY" "${placeholder "out"}/bin")
    (lib.cmakeBool "ICOMMANDS_INSTALL_SYMLINKS" false)
  ];

  meta = {
    inherit (irods.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = irods.meta.description + " CLI clients";
    longDescription = irods.meta.longDescription + ''

      This package provides the CLI clients, called 'icommands'.
    '';
  };
})
