# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  cmake,
  cpm-cmake,
  cudaPackages,
  fetchFromGitHub,
  fmt,
  git,
  jq,
  lib,
  nlohmann_json,
  stdenv,
  # passthru.updateScript
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rapids-cmake";
  version = "24.06.00";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rapidsai";
    repo = "rapids-cmake";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-sOVAAn8zdHOqkzT5kgHyPaNO9xSW0PF64O37OmpNp1k=";
  };

  nativeBuildInputs = [ jq ];

  postPatch =
    ''
      echo "Patching rapids-cmake/cpm/detail/download.cmake to use our vendored CPM.cmake"
      cp -a "${cpm-cmake}/share/cpm/CPM.cmake" rapids-cmake/cpm/detail/download.cmake
      chmod -R u+w rapids-cmake/cpm/detail/download.cmake
      substituteInPlace rapids-cmake/cpm/init.cmake \
        --replace-fail \
          "rapids_cpm_download()" \
          ""
    ''
    # NOTE: Whenever a package in rapids-cmake has patches, it is configured to forcibly download and patch the source.
    #       We get around this by manually patching those calls out. The list of patches is maintained here:
    #       https://github.com/rapidsai/rapids-cmake/blob/6bb3c5875ee8a3a74aafbba24fa2b6d2a80a4133/rapids-cmake/cpm/versions.json
    + ''
      echo "Removing patches from rapids-cmake/cpm/versions.json"
      jq '(.packages |= map_values(del(.patches)))' rapids-cmake/cpm/versions.json > _tmp.json
      mv _tmp.json rapids-cmake/cpm/versions.json
    '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/cmake/${finalAttrs.pname}"
    cp -a . "$out/share/cmake/${finalAttrs.pname}"
    runHook postInstall
  '';

  # NOTE: Without git, using this package throws errors when attempting to download something.
  #       Unfortunately, it's not easy to tell *what* it was trying to download.
  #       By including git, we at least get a log message that tells us what was attempted.
  # NOTE: Declaring these as host -> target dependencies means that when our package is included in a consumer's
  #       nativeBuildInputs, these dependencies will be included in the consumer's nativeBuildInputs as well.
  propagatedBuildInputs = [
    cmake
    git
  ];

  # NOTE: We must declare these as target -> target dependencies to ensure that they are included in the
  #       consumer's buildInputs.
  depsTargetTargetPropagated = [
    fmt
    nlohmann_json
  ];

  # TODO: Most of this should be done with setup hooks.
  passthru =
    let
      inherit (lib.strings) cmakeBool cmakeFeature;
      inherit (finalAttrs.finalPackage)
        data
        name
        outPath
        pname
        utilities
        version
        ;
    in
    {
      data = {
        cmakeFlags = [
          (cmakeBool "CPM_USE_LOCAL_PACKAGES" true)
          (cmakeBool "CPM_USE_LOCAL_PACKAGES_ONLY" true)
          (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
        ];
        rapids-cmake-dir = "${outPath}/share/cmake/${pname}";
      };
      utilities = {
        copyTo = path: ''
          if [[ -z "${path}" ]]; then
            echo "${name}: No path (or empty path) provided"
            exit 1
          fi
          echo "${name}: Copying to ${path}"
          cp -a "${data.rapids-cmake-dir}" "${path}"
          if (( $? != 0 )); then
            echo "${name}: Failed to copy ${data.rapids-cmake-dir} to ${path}"
            exit 1
          fi
          echo "${name}: Setting permissions on ${path}"
          chmod -R u+w "${path}"
          if (( $? != 0 )); then
            echo "${name}: Failed to set permissions on ${path}"
            exit 1
          fi
        '';
        # Copies the output to src/cmake/rapids-cmake.
        # Wrapped with newlines to make it easier to concatenate with other commands.
        copyToCmakeDir = utilities.copyTo "./cmake/${pname}";
      };
      updateScript = gitUpdater {
        inherit pname version;
        rev-prefix = "v";
      };
    };

  meta = with lib; {
    description = "A collection of CMake modules that are useful for all CUDA RAPIDS projects";
    homepage = "https://docs.rapids.ai/api/rapids-cmake/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ connorbaker ] ++ teams.cuda.members;
  };
})
