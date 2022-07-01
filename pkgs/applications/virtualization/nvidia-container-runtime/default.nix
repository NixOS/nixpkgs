{ lib
, glibc
, fetchFromGitHub
, makeWrapper
, buildGoPackage
, linkFarm
, writeShellScript
, containerRuntimePath
, configTemplate
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
buildGoPackage rec {
  pname = "nvidia-container-runtime";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+LZjsN/tKqsPJamoI8xo9LFv14c3e9vVlSP4NJhElcs=";
  };

  goPackagePath = "github.com/nvidia/nvidia-container-runtime";
  ldflags = [ "-s" "-w" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/etc/nvidia-container-runtime

    # nvidia-container-runtime invokes docker-runc or runc if that isn't
    # available on PATH.
    #
    # Also set XDG_CONFIG_HOME if it isn't already to allow overriding
    # configuration. This in turn allows users to have the nvidia container
    # runtime enabled for any number of higher level runtimes like docker and
    # podman, i.e., there's no need to have mutually exclusivity on what high
    # level runtime can enable the nvidia runtime because each high level
    # runtime has its own config.toml file.
    wrapProgram $out/bin/nvidia-container-runtime \
      --run "${warnIfXdgConfigHomeIsSet}" \
      --prefix PATH : ${isolatedContainerRuntimePath} \
      --set-default XDG_CONFIG_HOME $out/etc

    cp ${configTemplate} $out/etc/nvidia-container-runtime/config.toml

    substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
      --subst-var-by glibcbin ${lib.getBin glibc}
  '';

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/nvidia-container-runtime";
    description = "NVIDIA container runtime";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
