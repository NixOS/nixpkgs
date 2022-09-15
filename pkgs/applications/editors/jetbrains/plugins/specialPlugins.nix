{ delve, autoPatchelfHook, stdenv }:
# This is a list of plugins that need special treatment. For example, the go plugin (id is 9568) comes with delve, a
# debugger, but that needs various linking fixes. The changes here replace it with the system one.
{
  "631" = { # Python
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
  };
  "7322" = {  # Python community edition
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
  };
  "8182" = { # Rust
    nativeBuildInputs = [ autoPatchelfHook ];
    commands = "chmod +x -R bin";
  };
  "9568" = {  # Go
    buildInputs = [ delve ];
    commands = let
      arch = (if stdenv.isLinux then "linux" else "mac") + (if stdenv.isAarch64 then "arm" else "");
    in "ln -sf ${delve}/bin/dlv lib/dlv/${arch}/dlv";
  };
}
