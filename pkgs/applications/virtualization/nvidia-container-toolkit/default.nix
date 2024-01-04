{ lib
, glibc
, fetchFromGitLab
, makeWrapper
, buildGoModule
, linkFarm
, writeShellScript
, containerRuntimePath
, configTemplate ? null
, libnvidia-container
}:
let
  isolatedContainerRuntimePath = linkFarm "isolated_container_runtime_path" [
    {
      name = "runc";
      path = containerRuntimePath;
    }
  ];
  warnIfXdgConfigHomeIsSet = writeShellScript "warn_if_xdg_config_home_is_set" ''
    set -eo pipefail

    if [ -n "$XDG_CONFIG_HOME" ]; then
      echo >&2 "$(tput setaf 3)warning: \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME$(tput sgr 0)"
    fi
  '';
in
buildGoModule rec {
  pname = "container-toolkit";
  version = "1.14.3";

  src = fetchFromGitLab {
    owner = "nvidia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i2OWqP9HCccSEAlDlONTlwZOBV15uQFeLT5jEQTceyg=";
  };

  vendorHash = null;

  inherit configTemplate;
  postPatch = ''
    # Patch nvidiaCTKDefaultFilePath, nvidiaContainerRuntimeHookDefaultPath, etc
    substituteInPlace internal/config/config.go pkg/nvcdi/lib.go \
      --replace \
        "/usr/bin" \
        "$out/bin"
  '';

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeWrapper ];

  preConfigure = ''
    # Ensure the runc symlink isn't broken:
    if ! readlink --quiet --canonicalize-existing "${isolatedContainerRuntimePath}/runc" ; then
      echo "${isolatedContainerRuntimePath}/runc: broken symlink" >&2
      exit 1
    fi
  '';

  checkFlags =
    let
      skippedTests = [
        # Disable tests executing nvidia-container-runtime command.
        "TestGoodInput"
        "TestDuplicateHook"
      ];
    in
    [ "-skip" "${builtins.concatStringsSep "|" skippedTests}" ];

  postInstall = ''
    if [[ -n "$configTemplate" ]] ; then
      mkdir -p $out/etc/nvidia-container-runtime
      cp "$configTemplate" $out/etc/nvidia-container-runtime/config.toml

      substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
        --subst-var-by glibcbin ${lib.getBin glibc}
    fi

    # nvidia-container-runtime invokes docker-runc or runc if that isn't
    # available on PATH.
    #
    # Also set XDG_CONFIG_HOME if it isn't already to allow overriding
    # configuration. This in turn allows users to have the nvidia container
    # runtime enabled for any number of higher level runtimes like docker and
    # podman, i.e., there's no need to have mutually exclusivity on what high
    # level runtime can enable the nvidia runtime because each high level
    # runtime has its own config.toml file.
    declare -a wrapRuncFlags
    wrapRuncFlags+=(
      --run "${warnIfXdgConfigHomeIsSet}"
      --prefix PATH : ${isolatedContainerRuntimePath}:${libnvidia-container}/bin
    )
    if [[ -d "$out/etc" ]] ; then
      wrapRuncFlags+=( --set-default XDG_CONFIG_HOME "$out/etc" )
    fi
    wrapProgram $out/bin/nvidia-container-runtime "''${wrapRuncFlags[@]}"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/nvidia/container-toolkit/container-toolkit";
    description = "NVIDIA Container Toolkit";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
