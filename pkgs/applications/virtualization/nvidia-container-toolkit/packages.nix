{
  lib,
  newScope,
  docker,
  libnvidia-container,
  runc,
  symlinkJoin,
}:

lib.makeScope newScope (
  self: {

    nvidia-container-toolkit = self.callPackage ./. {
      containerRuntimePath = "${docker}/libexec/docker/docker";
    };

    # Keeping around for compatibility.
    # Setting the default `config.toml` is no longer necessary.
    nvidia-container-toolkit-docker = self.nvidia-container-toolkit.override {
      configTemplate = ../nvidia-docker/config.toml;
    };
    nvidia-container-toolkit-podman = self.nvidia-container-toolkit.override {
      containerRuntimePath = lib.getExe runc;
      configTemplate = ../nvidia-podman/config.toml;
    };

    nvidia-docker = symlinkJoin {
      name = "nvidia-docker";
      paths = [
        libnvidia-container
        self.nvidia-docker-unwrapped
        self.nvidia-container-toolkit-docker
      ];
    };
    nvidia-docker-unwrapped = self.callPackage ../nvidia-docker { };

    nvidia-podman = symlinkJoin {
      name = "nvidia-podman";
      paths = [
        libnvidia-container
        self.nvidia-container-toolkit-podman
      ];
    };
  }
)
