{
  lib,
  newScope,
  docker,
  libnvidia-container,
  runc,
  symlinkJoin,
}:

# Note this scope isn't recursed into, at the time of writing.
lib.makeScope newScope (self: {

  # The config is only exposed as an attrset so that the user may reach the
  # deafult values, for inspectability purposes.
  dockerConfig = {
    disable-require = false;
    #swarm-resource = "DOCKER_RESOURCE_GPU"

    nvidia-container-cli = {
      #root = "/run/nvidia/driver";
      #path = "/usr/bin/nvidia-container-cli";
      environment = [ ];
      #debug = "/var/log/nvidia-container-runtime-hook.log";
      ldcache = "/tmp/ld.so.cache";
      load-kmods = true;
      #no-cgroups = false;
      #user = "root:video";
      ldconfig = "@@glibcbin@/bin/ldconfig";
    };
  };
  nvidia-container-toolkit-docker = self.callPackage ./package.nix {
    containerRuntimePath = "${docker}/libexec/docker/docker";
    configTemplate = self.dockerConfig;
  };

  podmanConfig = {
    disable-require = true;
    #swarm-resource = "DOCKER_RESOURCE_GPU";

    nvidia-container-cli = {
      #root = "/run/nvidia/driver";
      #path = "/usr/bin/nvidia-container-cli";
      environment = [ ];
      #debug = "/var/log/nvidia-container-runtime-hook.log";
      ldcache = "/tmp/ld.so.cache";
      load-kmods = true;
      no-cgroups = true;
      #user = "root:video";
      ldconfig = "@@glibcbin@/bin/ldconfig";
    };
  };
  nvidia-container-toolkit-podman = self.nvidia-container-toolkit-docker.override {
    containerRuntimePath = lib.getExe runc;

    configTemplate = self.podmanConfig;
  };

  nvidia-docker = symlinkJoin {
    name = "nvidia-docker";
    paths = [
      libnvidia-container
      self.nvidia-docker-unwrapped
      self.nvidia-container-toolkit-docker
    ];
    inherit (self.nvidia-docker-unwrapped) meta;
  };
  nvidia-docker-unwrapped = self.callPackage ./nvidia-docker.nix { };

  nvidia-podman = symlinkJoin {
    name = "nvidia-podman";
    paths = [
      libnvidia-container
      self.nvidia-container-toolkit-podman
    ];
    inherit (self.nvidia-container-toolkit-podman) meta;
  };
})
