{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  linphoneSdkVersion,
  linphoneSdkHash,
}:
let
  # linphone-sdk is hosted on BC's Gitlab instance, however since it imposes
  # a heavy rate limit / throttling, we use their GitHub mirror instead.
  #
  # Note that `linphone-sdk` has many submodules, some of which include
  # vendored forks of third-party packages. However, we intentionally
  # do _not_ use them, since those that are forks of third-party projects
  # _only_ exist on BC's GitLab.
  #
  # Instead, we use the upstream packages from nixpkgs instead wherever possible.
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "linphone-sdk";
    tag = linphoneSdkVersion;
    hash = linphoneSdkHash;
  };
in
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

      inherit src;

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
