{
  lib,
  newScope,
  symlinkJoin,
}:

# Note this scope isn't recursed into, at the time of writing.
lib.makeScope newScope (
  self: {

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
      configTemplate = self.dockerConfig;
    };

    nvidia-docker = symlinkJoin {
      name = "nvidia-docker";
      paths = [
        self.nvidia-docker-unwrapped
        self.nvidia-container-toolkit-docker
      ];
      inherit (self.nvidia-docker-unwrapped) meta;
    };
    nvidia-docker-unwrapped =
      self.callPackage ./nvidia-docker.nix { };
  }
)
