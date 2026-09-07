{
  lib,
  newScope,
  symlinkJoin,
}:

# Note this scope isn't recursed into, at the time of writing.
lib.makeScope newScope (self: {
  nvidia-container-toolkit-docker = self.callPackage ./package.nix { };

  nvidia-docker = symlinkJoin {
    name = "nvidia-docker";
    paths = [
      self.nvidia-docker-unwrapped
      self.nvidia-container-toolkit-docker
    ];
    inherit (self.nvidia-docker-unwrapped) meta;
  };
  nvidia-docker-unwrapped = self.callPackage ./nvidia-docker.nix { };
})
