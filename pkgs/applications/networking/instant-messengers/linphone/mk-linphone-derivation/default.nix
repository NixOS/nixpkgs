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
  # a heavy rate limit / throttling when attempting to fetch submodules, we use their
  # GitHub mirror instead.
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "linphone-sdk";
    tag = linphoneSdkVersion;
    hash = linphoneSdkHash;
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git remote add origin https://github.com/BelledonneCommunications/linphone-sdk.git
      git reset --hard HEAD
      # `external` submodules are hardcoded to resolve to BC's Gitlab instance,
      # however, since we manually package all required external modules anyway,
      # we do not need to also fetch them here.
      #
      # We also use `--jobs 1` to avoid hitting BC's rate limit for the handful of
      # hardcoded submodules that we _do_ need.
      for submodule in $(git config --file .gitmodules --get-regexp path | awk '{print $2}' | grep -v '^external/.*$'); do
        git submodule update --init --recursive --jobs 1 "$submodule"
      done
      find "$out" -name .git -type d -print0 | xargs -0 rm -rf
    '';
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
