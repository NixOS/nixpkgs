{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
  linphoneSdkVersion,
  linphoneSdkHash,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "sourceRoot"
    "version"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      sourceRoot ? finalAttrs.pname,
      nativeBuildInputs ? [ ],
      cmakeFlags ? [ ],
      ...
    }@args:
    {
      version = linphoneSdkVersion;

      src = fetchFromGitLab {
        domain = "gitlab.linphone.org";
        owner = "public";
        group = "BC";
        repo = "linphone-sdk";
        tag = linphoneSdkVersion;
        hash = linphoneSdkHash;
        fetchSubmodules = true;
      };

      nativeBuildInputs = [
        cmake
      ]
      ++ nativeBuildInputs;

      sourceRoot = "${finalAttrs.src.name}/${sourceRoot}";

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=ON"
      ]
      ++ cmakeFlags;

      meta = {
        homepage = "https://gitlab.linphone.org/BC/public/linphone-sdk";
        # maintainers for all linphone packages
        maintainers = [
          lib.maintainers.jluttine
          lib.maintainers.naxdy
        ];
        platforms = lib.platforms.all;
      }
      // (lib.optionalAttrs (args ? meta) args.meta);
    };
}
