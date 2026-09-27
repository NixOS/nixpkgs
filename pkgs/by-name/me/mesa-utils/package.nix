{
  mesa-demos,
  symlinkJoin,
}:

# Top-level package exposing the essential Mesa utility binaries (glxinfo,
# glxgears, eglinfo, vkgears, etc.) from the `utils` output of mesa-demos.
# Provided as a separate attribute so consumers that only need the utilities
# can avoid the full mesa-demos closure.
symlinkJoin {
  pname = "mesa-utils";
  inherit (mesa-demos) version;

  strictDeps = true;
  __structuredAttrs = true;

  paths = [ mesa-demos.utils ];

  meta = mesa-demos.meta // {
    description = "Essential Mesa utilities (glxinfo, glxgears, eglinfo, vkgears, etc.)";
    mainProgram = "glxinfo";
  };
}
